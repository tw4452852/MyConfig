default:
	./install.sh

ALL= ./MyConfig/bin \
	 ./MyConfig/config \
	 ./MyConfig/submodules \
	 ./MyConfig/Makefile \
	 ./MyConfig/skin
pkt:
	cd .. && tar -czf myconfig.tar.gz $(ALL) && cd -
