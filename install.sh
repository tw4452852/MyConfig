#!/bin/bash -e
#set -x

TOP_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
HOME_DIR="$(cd ~ && pwd)"
MYROOT="${HOME_DIR}/MyRoot"
GOROOT="${HOME_DIR}/goroot"
GOPATH="${HOME_DIR}/go"

recursive_link() {
	# directories first
	cd "$1" && find . -type d -exec sh -c "[ ! -e \"$2/{}\" ] && ln -sv \"$1/{}\" \"$2/{}\"" \;
	# links then
	cd "$1" && find . -type l -exec sh -c "[ ! -e \"$2/{}\" ] && ln -sv \"$1/{}\" \"$2/{}\"" \;
	# files at last
	cd "$1" && find . -type f -exec sh -c "[ ! -e \"$2/{}\" ] && ln -sv \"$1/{}\" \"$2/{}\"" \;
}

echo "install configuration... "

case "$(uname)" in
*MINGW* | *WIN32* ) # Windows
	cp -fr ${TOP_DIR}/config/.vim ${HOME_DIR}/vimfiles
	cp -fr ${TOP_DIR}/config/.vimrc ${HOME_DIR}/_vimrc
	cp -fr ${TOP_DIR}/config/.gitconfig ${HOME_DIR}
	mkdir -p ${HOME_DIR}/.ssh
	cp -fr ${TOP_DIR}/config/ssh_config ${HOME_DIR}/.ssh/config
	;;
*) # Linux
	# create necessary directories
	mkdir -p ${MYROOT}/bin
	mkdir -p ${GOROOT}
	mkdir -p ${GOPATH}/bin
	mkdir -p ${GOPATH}/pkg
	mkdir -p ${GOPATH}/src

	# home config files
	recursive_link "${TOP_DIR}/config/home" "${HOME_DIR}"
	;;
esac

echo "done"
