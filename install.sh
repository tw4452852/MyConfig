#!/bin/bash
set +e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates'
	exit 1
fi

TOP_DIR="$(pwd)"
HOME_DIR="$(cd ${HOME_DIR} && pwd)"
MYROOT=${HOME_DIR}/MyRoot
GOROOT=${HOME_DIR}/goroot
GOPATH=${HOME_DIR}/go
FONTS_DIR=${HOME_DIR}/.fonts
FONTS_CONF_DIR=${HOME_DIR}/.config/fonconfig

check_tools() {
	echo ">>> test necessary tools ..."

	git --version >/dev/null
	if [[ $? -ne 0 ]]; then
		echo 'You must install git before install the environment' 
		echo "<<< git doesn't exist"
		exit 1
	fi
	hg --version >/dev/null
	if [[ $? -ne 0 ]]; then
		echo 'You must install mercurial before install the environment' 
		echo "<<< mercurial doesn't exist"
		exit 1
	fi

	echo "<<< test necessary tools done"
}

setup_config() {
	echo ">>> restore myself config ..."

	case "$(uname)" in
	*MINGW* | *WIN32* ) # Windows
		rm -fr ${HOME_DIR}/vimfiles
		cp -fr ${TOP_DIR}/config/.vim ${HOME_DIR}/vimfiles
		rm -fr ${HOME_DIR}/_vimrc
		cp -fr ${TOP_DIR}/config/.vimrc ${HOME_DIR}/_vimrc
		cp -fr ${TOP_DIR}/config/.gitconfig ${HOME_DIR}
		mkdir -p ${HOME_DIR}/.ssh
		cp -fr ${TOP_DIR}/config/ssh_config ${HOME_DIR}/.ssh/config
		;;
	*)
		#mkdir myself dirs
		mkdir -p ${MYROOT}/bin
		mkdir -p ${GOROOT}
		mkdir -p ${GOPATH}/bin
		mkdir -p ${GOPATH}/pkg
		mkdir -p ${GOPATH}/src

		#config files
		if [[ -d ${HOME_DIR}/.emacs.d ]]; then
			rm -fr ${HOME_DIR}/.emacs.d
		fi
		ln -sf ${TOP_DIR}/config/.emacs.d ${HOME_DIR}
		if [[ -d ${HOME_DIR}/.vim ]]; then
			rm -fr ${HOME_DIR}/.vim
		fi
		ln -sf ${TOP_DIR}/config/.vim ${HOME_DIR}
		mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
		if [[ -d ${XDG_CONFIG_HOME}/nvim ]]; then
		    rm -fr ${XDG_CONFIG_HOME}/nvim
		fi
		ln -sf ${TOP_DIR}/config/.vim $XDG_CONFIG_HOME/nvim
		ln -sf ${TOP_DIR}/config/.gitconfig ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.git-template ${HOME_DIR}
		mkdir -p ${HOME_DIR}/.ssh
		ln -sf ${TOP_DIR}/config/ssh_config ${HOME_DIR}/.ssh/config
		ln -sf ${TOP_DIR}/config/.tmux.conf ${HOME_DIR}
		if [[ -d ${HOME_DIR}/.oh-my-zsh ]]; then
			rm -fr ${HOME_DIR}/.oh-my-zsh
		fi
		ln -sf ${TOP_DIR}/config/.oh-my-zsh ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.zshrc ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.zsh ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.fzf.zsh ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.xinitrc ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.Xresources ${HOME_DIR}
		ln -Pf ${TOP_DIR}/config/.procmailrc ${HOME_DIR}
		ln -Pf ${TOP_DIR}/config/.muttrc ${HOME_DIR}
		ln -Pf ${TOP_DIR}/config/.fetchmailrc ${HOME_DIR}
		ln -sf ${TOP_DIR}/config/.autoload.sh ${HOME_DIR}
		if [[ -d ${HOME_DIR}/.autoload.d ]]; then
			rm -fr ${HOME_DIR}/.autoload.d
		fi
		ln -sf ${TOP_DIR}/config/.autoload.d ${HOME_DIR}
		if [[ -d ${HOME_DIR}/.dwm ]]; then
			rm -fr ${HOME_DIR}/.dwm
		fi
		ln -sf ${TOP_DIR}/config/.dwm ${HOME_DIR}

		# elvish stuff
		mkdir -p ${HOME_DIR}/.elvish
		for p in "${TOP_DIR}/config/.elvish/*" ; do
			ln -sf ${p} ${HOME_DIR}/.elvish/
		done

		#bins
		for mybin in $(find ${TOP_DIR}/bin/ -type f); do
			ln -sf ${mybin} ${MYROOT}/bin/
		done

		#font
		mkdir -p ${FONTS_CONF_DIR}
		ln -sf ${TOP_DIR}/config/.fonts.conf ${FONTS_CONF_DIR}
		mkdir -p ${FONTS_DIR}
		for f in "${TOP_DIR}/font/*"; do
			ln -sf $f ${FONTS_DIR}
		done

		export PKG_CONFIG_PATH=${MYROOT}/lib/pkgconfig/:$PKG_CONFIG_PATH
		export PATH=${MYROOT}/bin/:$PATH
		;;
	esac

	echo "<<< restore myself config done"
}

setup_software() {
	# Windows
	case "$(uname)" in
		*MINGW* | *WIN32* )
			echo "nothing to do in windows"
			exit 0
			;;
	esac

	# Gentoo
	case "$(uname -r)" in
		*gentoo*)
			echo "use the ebuild to setup software in gentoo"
			#exit 0
			;;
	esac

	check_tools

	#fetch the submodule src
	git sm init

	#build the software

	# dwm
	echo ">>> install dwm ..."
	pkg-config --exists x11
	if [[ $? -ne 0 ]]; then
		echo "you must install x11 lib firstly"
		echo "<<< install dwm failed"
	else
		git sm update submodules/dwm
		cd ${TOP_DIR}/submodules/dwm
		# use myself config.h
		ln -sf ${TOP_DIR}/config/dwm.conf.h ./config.h
		# change install dir
		sed -i -e "/^PREFIX/c PREFIX = ${MYROOT}" config.mk &&
		make clean install
		if [[ $? -ne 0 ]]; then
			echo "install dwm failed"
			exit 1
		fi
	fi
	echo "<<< install dwm done"

	#libevent (needed by tmux)
	echo ">>> install libevent ..."
	pkg-config --exists libevent
	if [[ $? -ne 0 ]]; then
		git sm update submodules/libevent
		cd ${TOP_DIR}/submodules/libevent
		git co master
		./autogen.sh &&
		./configure --prefix=${MYROOT} &&
		make &&
		make install
		if [[ $? -ne 0 ]]; then
			echo 'install libevent failed' 
			exit 1
		fi
	else
		echo "libevent has been installed, skip"
	fi
	echo "<<< install libevent done"

	#tmux
	echo ">>> install tmux ..."
	which tmux
	if [[ $? -ne 0 ]]; then
		git sm update submodules/tmux
		cd ${TOP_DIR}/submodules/tmux
		git co master
		./autogen.sh &&
		./configure --prefix=${MYROOT} &&
		make &&
		make install
		if [[ $? -ne 0 ]]; then
			echo 'install tmux failed' 
			exit 1
		fi
	else
		echo "tmux has been installed, skip"
	fi
	echo "<<< install tmux done"

	#go
	echo ">>> install go ..."
	which go
	if [[ $? -ne 0 ]]; then
		hg clone http://code.google.com/p/go ${GOROOT} &&
		cd ${GOROOT}/src &&
		./make.bash
		if [[ $? -ne 0 ]]; then
			echo "install go failed" 
			exit 1
		fi
	else
		echo "go has been installed, just update"
		cd ${GOROOT} &&
		hg pull
		if [[ $? -ne 0 ]]; then
			echo "update go failed"
			exit 1
		fi
		hg update | grep "0 files updated, 0 files merged, 0 files removed, 0 files unresolved"
		if [[ $? -ne 0 ]]; then
			cd ./src &&
			./make.bash
			if [[ $? -ne 0 ]]; then
				echo "build go failed"
				exit 1
			fi
		fi
	fi
	echo "<<< install go done"

	#zsh
	echo ">>> install zsh ..."
	which zsh
	if [[ $? -ne 0 ]]; then
		git sm update submodules/zsh
		cd ${TOP_DIR}/submodules/zsh
		git co master
		./Util/preconfig;
		./configure --prefix=${MYROOT};
		make;
		make install;
	else
		echo "zsh has been install, skip"
	fi
	echo "maybe you should use following cmd:
		sudo echo \`which zsh\` >> /etc/shells
		chsh -s \`which zsh\`"

	echo "<<< install zsh done"
}

# Main
while getopts ":cs" opt 
do
	case "${opt}" in
		"c")
			setup_config
			;;
		"s")
			setup_software
			;;
	esac
done

echo 'Well done!'
