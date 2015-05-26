# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="tw"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

#ssh-agent
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(ssh-agent history-substring-search)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export LC_ALL="en_US.UTF-8"

export CSCOPE_EDITOR=vim
export EDITOR=vim

export GOROOT=~/goroot
export GOPATH=~/golib

export CDPATH=.:$GOPATH/src:$GOROOT/src/pkg:$CDPATH
export PATH=~/MyRoot/bin:$PATH:$GOROOT/bin:$GOPATH/bin

#autoload
source $HOME/.autoload.sh

#tmux
#if which test 2>&1 >/dev/null;then
	#if test -z ${TMUX};then
		#tmux -2
	#fi
	#while test -z ${TMUX};do
		#tmux -2 attach || break
	#done
#fi

# fzf
export FZF_DEFAULT_COMMAND='pt -l -g ".*"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# vi mode
bindkey -v
VIMODE='-- INSERT --'
function zle-line-init zle-keymap-select {
	VIMODE="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
RPROMPT='%{$fg[green]%}${VIMODE}%{$reset_color%}'

