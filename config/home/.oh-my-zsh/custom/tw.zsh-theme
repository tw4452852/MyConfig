PROMPT=$'%/ [%n@%m] %(1j.%j.)
%(?..%?)> '

# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}
zle -N zle-keymap-select
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/<<<}/(main|viins)/}"
}
RPS1='$(vi_mode_prompt_info)'
