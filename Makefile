DEST_DIR = $(HOME)/MyConfig/
ALL= ./MyConfig/bin \
	 ./MyConfig/skin \
	 ./MyConfig/config \
	 ./MyConfig/submodules \
	 ./MyConfig/Makefile \
	 ./MyConfig/install.sh \
	 ./MyConfig/myconfig-1.0.ebuild

default:
	./install.sh -cs

config:
	./install.sh -c

software:
	./install.sh -s

install:
	mkdir $(DEST_DIR)
	cp -fr ./* $(DEST_DIR)

pkt:
	cd .. && tar -czf myconfig.tar.gz $(ALL) && cd -
