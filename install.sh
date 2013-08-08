#!/bin/bash
set +e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates'
	exit 1
fi
TOP="$(pwd)"

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
	*MINGW* | *WIN32* | *CYGWIN*) # Windows
		rm -fr ~/vimfiles
		cp -fr ${TOP}/config/.vim ~/vimfiles
		rm -fr ~/_vimrc
		cp -fr ${TOP}/config/.vimrc ~/_vimrc
		cp -fr ${TOP}/config/.gitconfig ~
		cp -fr ${TOP}/config/ssh_config ~/.ssh/config
		;;
	*)
		#mkdir myself dirs
		mkdir -p ~/MyRoot/bin
		mkdir -p ~/goroot
		mkdir -p ~/golib/bin
		mkdir -p ~/golib/pkg
		mkdir -p ~/golib/src

		#config files
		if [[ -d ~/.vim ]]; then
			rm -fr ~/.vim
		fi
		ln -sf ${TOP}/config/.vim ~
		ln -sf ${TOP}/config/.vimrc ~
		ln -sf ${TOP}/config/.gitconfig ~
		ln -sf ${TOP}/config/ssh_config ~/.ssh/config
		ln -sf ${TOP}/config/.tmux.conf ~
		if [[ -d ~/.oh-my-zsh ]]; then
			rm -fr ~/.oh-my-zsh
		fi
		ln -sf ${TOP}/config/.oh-my-zsh ~
		ln -sf ${TOP}/config/.zshrc ~
		ln -sf ${TOP}/config/.xinitrc ~
		ln -sf ${TOP}/config/.Xresources ~
		ln -sf ${TOP}/config/.autoload.sh ~
		if [[ -d ~/.autoload.d ]]; then
			rm -fr ~/.autoload.d
		fi
		ln -sf ${TOP}/config/.autoload.d ~

		#bins
		for mybin in $(find ${TOP}/bin/ -type f); do
			ln -sf ${mybin} ~/MyRoot/bin/
		done

		#font
		mkdir -p ~/.fonts
		ln -sf ${TOP}/font/Lucida\ Console.ttf ~/.fonts/

		export PKG_CONFIG_PATH=~/MyRoot/lib/pkgconfig/:$PKG_CONFIG_PATH
		export PATH=~/MyRoot/bin/:$PATH
		;;
	esac

	echo "<<< restore myself config done"
}

setup_software() {
	# Windows
	case "$(uname)" in
		*MINGW* | *WIN32* | *CYGWIN*)
			echo "nothing to do in windows"
			exit 0
			;;
	esac

	# Gentoo
	case "$(uname -r)" in
		*gentoo*)
			echo "use the ebuild to setup software in gentoo"
			exit 0
			;;
	esac

	check_tools

	BASE="$(cd ~ && pwd)"

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
		cd ${TOP}/submodules/dwm
		# use myself config.h
		ln -sf ${TOP}/config/dwm.conf.h ./config.h
		# change install dir
		sed -i -e "/^PREFIX/c PREFIX = ${BASE}/MyRoot/" config.mk &&
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
		cd ${TOP}/submodules/libevent
		git co master
		./autogen.sh &&
		./configure --prefix=$BASE/MyRoot/ &&
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
		cd ${TOP}/submodules/tmux
		git co master
		./autogen.sh &&
		./configure --prefix=$BASE/MyRoot/ &&
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
		export GOROOT=
		export GOPATH=
		hg clone http://code.google.com/p/go ~/goroot &&
		cd ~/goroot/src &&
		./make.bash
		if [[ $? -ne 0 ]]; then
			echo "install go failed" 
			exit 1
		fi
	else
		echo "go has been installed, just update"
		cd $GOROOT &&
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
		cd ${TOP}/submodules/zsh
		git co master
		./Util/preconfig;
		./configure --prefix=$BASE/MyRoot/;
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
