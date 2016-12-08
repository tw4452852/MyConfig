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
bindkey -s "\e," '$ANDROID_BUILD_TOP/out/target/product/x86_64/system'

# use <ctrl-x>p/n for history-beginning-search
bindkey '^xp' history-beginning-search-backward
bindkey '^xn' history-beginning-search-forward

# <alt-=> for copy-prev-shell-word
bindkey '\e=' copy-prev-shell-word

# no need to surround url with single quotation
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

echo "zsh stuff init done"
