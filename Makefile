default:
	./install.sh

ALL= ./MyConfig/bin \
	 ./MyConfig/skin \
	 ./MyConfig/config \
	 ./MyConfig/submodules \
	 ./MyConfig/Makefile \
	 ./MyConfig/install.sh
pkt:
	cd .. && tar -czf myconfig.tar.gz $(ALL) && cd -
