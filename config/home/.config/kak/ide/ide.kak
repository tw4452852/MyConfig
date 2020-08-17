# Basic layout
define-command ide -docstring "set up IDE layout" %{
    require-module tmux
    rename-client main
    set global jumpclient main
    tmux-terminal-impl 'splitw -h' kak -c %val{session} -e "rename-client tools"
    set global toolsclient tools
    tmux-terminal-impl 'splitw -v' kak -c %val{session} -e "rename-client docs"
    set global docsclient docs
    focus main
}
