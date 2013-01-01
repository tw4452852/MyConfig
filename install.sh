#!/bin/bash
set +e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates' 1 >&2
	exit 1
fi

#test the necessary tool
git --version >/dev/null
if [[ $? -ne 0 ]]; then
	echo 'You must install git before install the environment' 1 >&2
	exit 1
fi
hg --version >/dev/null
if [[ $? -ne 0 ]]; then
	echo 'You must install mercurial before install the environment' 1 >&2
	exit 1
fi

BASE="$(cd ~ && pwd)"

#mkdir myself dirs
mkdir -p ~/MyRoot/bin
mkdir -p ~/goroot
mkdir -p ~/golib/bin
mkdir -p ~/golib/pkg
mkdir -p ~/golib/src

#config files
if [[ -d ~/.vim ]]; then
	echo 'rm -fr ~/.vim' 1 >&2
	rm -fr ~/.vim
fi
ln -sf `pwd`/.vim ~
ln -sf `pwd`/.vimrc ~
ln -sf `pwd`/.gitconfig ~
ln -sf `pwd`/.tmux.conf ~
if [[ -d ~/.oh-my-zsh ]]; then
	echo 'rm -fr ~/.oh-my-zsh' 1 >&2
	rm -fr ~/.oh-my-zsh
fi
ln -sf `pwd`/.oh-my-zsh ~
ln -sf `pwd`/.zshrc ~

#tw_cscope
ln -sf `pwd`/bin/tw_cscope ~/MyRoot/bin/

export PKG_CONFIG_PATH=~/MyRoot/lib/pkgconfig/:$PKG_CONFIG_PATH
export PATH=~/MyRoot/bin/:$PATH

#fetch the submodule src
git sm init

#build the software
#libevent (needed by tmux)
pkg-config --exists libevent
if [[ $? -ne 0 ]]; then
	git sm update libevent
	cd libevent
	git co master
	./autogen.sh &&
	./configure --prefix=$BASE/MyRoot/ &&
	make &&
	make install
	if [[ $? -ne 0 ]]; then
		echo 'install libevent failed' 1 >&2
		exit 1
	fi
	cd -
fi

#tmux
which tmux
if [[ $? -ne 0 ]]; then
	git sm update tmux
	cd tmux
	git co master
	./autogen.sh &&
	./configure --prefix=$BASE/MyRoot/ &&
	make &&
	make install
	if [[ $? -ne 0 ]]; then
		echo 'install tmux failed' 1 >&2
		exit 1
	fi
	cd -
fi

#go
export GOROOT=
export GOPATH=
hg clone http://code.google.com/p/go ~/goroot &&
cd ~/goroot/src &&
./all.bash
if [[ $? -ne 0 ]]; then
	echo "install go failed" 1 >&2
	exit 1
fi
cd -

#zsh
which zsh
if [[ $? -ne 0 ]]; then
	git sm update zsh
	cd zsh
	git co master
	./Util/preconfig;
	./configure --prefix=$BASE/MyRoot/;
	make;
	make install;
	cd -
fi
#change default shell
if [[ $USER != root ]]; then
	sudo echo `which zsh` >> /etc/shells
	chsh -s `which zsh`
	if [[ $? -ne 0 ]]; then
		echo 'changing default shell failed' 1 >&2
		exit 1
	fi
fi

#use zsh
echo 'Well done, Reboot now' 1 >&2
