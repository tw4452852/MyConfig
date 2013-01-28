#!/bin/bash
set +e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates' 1 >&2
	exit 1
fi

#test the necessary tool
git --version
if [[ $? -ne 0 ]]; then
	echo 'You must install git before install the environment' 1 >&2
	exit 1
fi
hg --version
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
ln -sf `pwd`/.vim ~
ln -sf `pwd`/.vimrc ~
ln -sf `pwd`/.gitconfig ~
ln -sf `pwd`/.tmux.conf ~
ln -sf `pwd`/.oh-my-zsh ~
ln -sf `pwd`/.zshrc ~

#tw_cscope
ln -sf `pwd`/bin/tw_cscope ~/MyRoot/bin/

export PKG_CONFIG_PATH=~/MyRoot/lib/pkgconfig/:$PKG_CONFIG_PATH
export PATH=~/MyRoot/bin/:$PATH

#fetch the submodule src
git sm init
git sm update

#build the software
#libevent (needed by tmux)
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

#tmux
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

#zsh
cd zsh
git co master
./Util/preconfig;
./configure --prefix=$BASE/MyRoot/;
make;
make install;
cd -

#change default shell
chsh -s $BASE/MyRoot/bin/zsh
if [[ $? -ne 0 ]]; then
	echo 'changing default shell failed' 1 >&2
	exit 1
fi

#go
export GOROOT=''
export GOPATH=''
hg clone http://code.google.com/p/go ~/goroot &&
cd ~/goroot/src &&
./all.bash
if [[ $? -ne 0 ]]; then
	echo "install go failed" 1 >&2
	exit 1
fi
cd -

#use zsh
source ~/.zshrc
