#!/bin/bash
set +e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates' 1 >&2
	exit 1
fi

BASE="$(cd ~ && pwd)"

#mkdir myself dirs
mkdir -p ~/MyRoot/bin
mkdir -p ~/goroot
mkdir -p ~/golib

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


#python2.7
cd python-2.7
./configure --prefix=$BASE/MyRoot/ &&
make &&
make install
if [[ $? -ne 0 ]]; then
	exit 1
fi
cd -

#mercurial
cd mercurial
git co master
make all &&
make PREFIX=$BASE/MyRoot/ install 
if [[ $? -ne 0 ]]; then
	exit 1
fi
cd -
