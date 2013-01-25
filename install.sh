#!/bin/bash
set -e
if [[ ! -f install.sh ]]; then
	echo 'install.sh must be run in where it locates' 1 >&2
	exit 1
fi

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
ln -sf `pwd`/tw_cscope ~/MyRoot/bin/

#build the software
#libevent
cd libevent
./autogen.sh &&
./configure --prefix=~/MyRoot/ &&
make && make install
cd -

#tmux
cd tmux
./autogen.sh &&
./configure --prefix=~/MyRoot/ &&
make && make install
cd -

#zsh
cd zsh
./Util/preconfig &&
./configure --prefix=~/MyRoot/ &&
make && make install
cd -
