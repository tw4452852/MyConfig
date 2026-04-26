#if 0
set -e

R=/tmp/bpftrace
LIBBPF_INC=/usr/include

mkdir -p "$R"

[ -f "$R/vmlinux.h" ] || bpftool btf dump file /sys/kernel/btf/vmlinux format c > "$R/vmlinux.h"
zig cc -g -O2 -target bpfel-freestanding -D__TARGET_ARCH_x86 -I"$LIBBPF_INC" -I"$R" -c "$0" -o "$R/bpf.o"
bpftool gen skeleton "$R/bpf.o" > "$R/skel.h"
zig cc -I"$LIBBPF_INC" -I"$R" -lbpf -o "$R/a.out" "$0"
sudo "$R/a.out"

exit 0
#endif

#ifdef __bpf__

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>
#include <bpf/bpf_core_read.h>

char LICENSE[] SEC("license") = "Dual BSD/GPL";

SEC("kprobe/do_unlinkat")
int BPF_KPROBE(do_unlinkat, int dfd, struct filename *name)
{
	pid_t pid;
	const char *filename;

	pid = bpf_get_current_pid_tgid() >> 32;
	filename = BPF_CORE_READ(name, name);
	bpf_printk("KPROBE ENTRY pid = %d, filename = %s\n", pid, filename);
	return 0;
}

SEC("kretprobe/do_unlinkat")
int BPF_KRETPROBE(do_unlinkat_exit, long ret)
{
	pid_t pid;

	pid = bpf_get_current_pid_tgid() >> 32;
	bpf_printk("KPROBE EXIT: pid = %d, ret = %ld\n", pid, ret);
	return 0;
}

#else

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <sys/resource.h>
#include <bpf/libbpf.h>
#include "skel.h"

int main(int argc, char **argv)
{
	struct bpf *skel;
	int err;

	/* Open load and verify BPF application */
	skel = bpf__open_and_load();
	if (!skel) {
		fprintf(stderr, "Failed to open BPF skeleton\n");
		return 1;
	}

	/* Attach tracepoint handler */
	err = bpf__attach(skel);
	if (err) {
		fprintf(stderr, "Failed to attach BPF skeleton\n");
		goto cleanup;
	}

	printf("Successfully started! Dumping kernel trace buffer:\n");
	system("bpftool prog tracelog");

cleanup:
	bpf__destroy(skel);
	return -err;
}
#endif
