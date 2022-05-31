evaluate-commands %sh{
  kcr init kakoune
}

hook global ModuleLoaded tmux %{
  alias global popup tmux-terminal-vertical
}

map -docstring 'Open files' global user m ': + kcr-fzf-files<ret>'
map -docstring 'Grep files' global user g ': + kcr-fzf-grep<ret>'
