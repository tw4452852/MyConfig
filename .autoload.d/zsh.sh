# environment {{{
_zdir=${ZDOTDIR:-$HOME}

# autoload functions
[[ -d $_zdir/.zsh/functions ]] &&
	fpath=($_zdir/.zsh/functions $fpath) &&
	autoload -U $_zdir/.zsh/functions/*(:t)

# modules
module_path=($_zdir/.zsh/modules $module_path)

#}}}

# options {{{
setopt multios
setopt extendedglob
# regard '' as '
setopt rc_quotes

# no duplicate history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

#}}}

# keymaps {{{
# use emacs mode by default
bindkey -e

# overwrite <alt-q> with push-line-or-edit
bindkey "\eq" push-line-or-edit

# use <alt-;> for commenting this line
bindkey "\e;" pound-insert

# use <alt-,> for "$ANDROID_BUILD_TOP/" literally
bindkey -s "\e," '$ANDROID_BUILD_TOP/out/target/product/x86_64/system'

# use <alt-p/n> for history-search-end
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end \
	history-search-end
zle -N history-beginning-search-forward-end \
	history-search-end
bindkey '\ep' history-beginning-search-backward-end
bindkey '\en' history-beginning-search-forward-end

# <alt-=> for copy-earlier-word
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '\e=' copy-earlier-word

# no need to surround url with single quotation
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# move by shell word
zsh-word-movement () {
	# see select-word-style for more
	local -a word_functions
	local f

	word_functions=(backward-kill-word backward-word
	capitalize-word down-case-word
	forward-word kill-word
	transpose-words up-case-word)

	if ! zle -l $word_functions[1]; then
		for f in $word_functions; do
			autoload -Uz $f-match
			zle -N zsh-$f $f-match
		done
	fi
	# set the style to shell
	zstyle ':zle:zsh-*' word-style shell
}
zsh-word-movement
unfunction zsh-word-movement
bindkey "\eB" zsh-backward-word
bindkey "\eF" zsh-forward-word
bindkey "\eW" zsh-backward-kill-word

# <alt-j> for jump-target
zle -N jump-target
bindkey '\ej' jump-target

# <space> for expanding abbreviation like 'iab' with Vim
typeset -A myiabs
myiabs=(
	"Ig"    "| grep"
	"Ip"    "| $PAGER"
	"Ih"    "| head"
	"It"    "| tail"
	"Iv"    "| $EDITOR -R -"
)
my-expand-abbrev() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
	LBUFFER+=${myiabs[$MATCH]:-$MATCH}
	zle self-insert
}
zle -N my-expand-abbrev
bindkey " " my-expand-abbrev
#}}}

# alias {{{
# suffix
alias -s pdf=zathura

# directory
hash -d A=~/code/android/5.1
hash -d V=~/.vim
hash -d T=~/tmp
hash -d Z=~/.zsh

#}}}

# misc {{{
# use more advanced run-help to support builtin and function
alias run-help >&/dev/null && unalias run-help
autoload run-help

# subreap
zmodload subreap 2>/dev/null && subreap

#}}}

echo "zsh stuff init done"
# vim: fdm=marker
