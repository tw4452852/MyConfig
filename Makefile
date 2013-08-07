default:
	./install.sh -cs

config:
	./install.sh -c

software:
	./install.sh -s

ALL= ./MyConfig/bin \
	 ./MyConfig/skin \
	 ./MyConfig/config \
	 ./MyConfig/submodules \
	 ./MyConfig/Makefile \
	 ./MyConfig/install.sh \
	 ./MyConfig/myconfig-1.0.ebuild
pkt:
	cd .. && tar -czf myconfig.tar.gz $(ALL) && cd -
