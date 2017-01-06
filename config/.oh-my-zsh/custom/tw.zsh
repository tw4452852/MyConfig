# environment {{{
_zdir=${ZDOTDIR:-$HOME}
typeset -U cdpath path module_path fpath

# autoload functions
[[ -d $_zdir/.zsh/functions ]] &&
  fpath=($_zdir/.zsh/functions $fpath) &&
  autoload -Uz $_zdir/.zsh/functions/*(:t)

# modules
module_path=($_zdir/.zsh/modules $module_path)

# exports
export LC_ALL="en_US.UTF-8"

if (( ${+commands[nvim]} )) then
  export CSCOPE_EDITOR=nvim
  export EDITOR=nvim
  export MANPAGER="nvim -c 'set ft=man' -"
elif (( ${+commands[vim]} )) then
  export CSCOPE_EDITOR=vim
  export EDITOR=vim
  export MANPAGER="vim -R -"
else
  # just leave as it is
fi

export GOROOT=~/goroot
export GOPATH=~/golib
cdpath=(${GOPATH}/src ${GOROOT}/src . $cdpath)
path=(~/MyRoot/bin ${GOROOT}/bin ${GOPATH}/bin $path)

(( ${+commands[pt]} )) && export FZF_DEFAULT_COMMAND='pt -l -g ".*"'
#}}}

# options {{{
setopt MULTIOS
# Treat the '#', '~' and '^' characters as part of patterns 
# for filename generation, etc. (An initial unquoted '~'
# always produces named directory expansion.)
# | $ grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z)
# searches for word not in compressed files
setopt EXTENDED_GLOB
# regard '' as '
setopt RC_QUOTES

# no duplicate history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# do *not* run all background jobs at a lower priority
unsetopt BG_NICE

# If this option is unset, output flow control via start/stop characters
# (usually assigned to ^S/^Q) disabled in the shell's editor.
unsetopt FLOW_CONTROL

# Don't push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT

#}}}

# keymaps {{{
# use emacs mode by default
bindkey -e

# use <ctrl-r/s> for history-incremental-pattern-search
autoload -Uz narrow-to-region
_history-incremental-preserving-pattern-search-backward () {
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^r" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

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
autoload -Uz url-quote-magic
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
bindkey -a '\ej' jump-target

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

# <alt-A> for android-dir-previous-wold
android-dir-previous-word() {
  integer posword
  zle .end-of-line

  autoload -Uz split-shell-arguments
  split-shell-arguments

  (( posword = REPLY ))
  (( posword < 2 )) && return
  (( posword & 1 )) && (( posword-- ))

  local match mbegin mend
  if [[ ${reply[posword]} == (#b)*(/system/*)## ]]; then
    LBUFFER+="${match[1]:h}"
  fi
}
zle -N android-dir-previous-word
bindkey '\eA' android-dir-previous-word

# <alt-c> for my-vi-change
my-vi-change() {
  zle .vi-change -K vicmd
}
zle -N my-vi-change
bindkey '\ec' my-vi-change
#}}}

# alias {{{
# suffix
alias -s pdf=zathura

# directory
hash -d A=~/code/android/5.1
hash -d P=~/public/android/5.1
hash -d T=~/tmp
hash -d V=~/.vim
hash -d Z=~/.oh-my-zsh/custom

#}}}

# misc {{{
# use more advanced run-help to support builtin and function
(( ${+aliases[run-help]} )) && unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git

# subreap
zmodload subreap 2>/dev/null && subreap

# watch login
watch=(all)
WATCHFMT='%n has %a %l from %M'
LOGCHECK=60

# set tmux window's name and pannel's title
_title() {
  case "$TERM" in
    (screen*|tmux*)
      # window's name
      [[ -n ${1} ]] && print -Pn "\033k${1}\033\\"
      # pannel's title
      [[ -n ${2} ]] && print -Pn "\033]2;${2}\033\\"
      ;;
    (*)
      # do nothing
  esac
}
_precmd() {
  _title "zsh"
}
_preexec() {
  local cmdline=${3}
  local cmds=(${(z)2})
  local cmd=${cmds[1]}

  # if `fg', retrieve the actual cmdline
  if [[ ${cmd} == fg ]]; then
    cmdline=${jobtexts[${cmds[2]:-%+}]}
    cmds=(${(z)cmdline})
    cmd=${cmds[1]}
  fi
  _title "${cmd}" "${cmdline}"
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd _precmd
add-zsh-hook -Uz preexec _preexec

#}}}

# vim: set fdm=marker et sw=2 ts=2 ft=sh:
