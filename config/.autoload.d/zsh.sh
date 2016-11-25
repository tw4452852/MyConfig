setopt multios
setopt correctall
setopt extendedglob

# use emacs mode by default
bindkey -e

# overwrite <alt-q> with push-line-or-edit
bindkey "\eq" push-line-or-edit

# use <alt-;> for commenting this line
bindkey "\e;" pound-insert

# use <alt-,> for "$ANDROID_BUILD_TOP/" literally
bindkey -s "\e," '$ANDROID_BUILD_TOP/'

# use <ctrl-n/p> for history-substring-search
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# no need to surround url with single quotation
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

echo "zsh stuff init done"
