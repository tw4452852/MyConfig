# Basic layout
define-command ide -docstring "set up IDE layout" %{
    require-module tmux
    rename-client main
    set global jumpclient main
    tmux-terminal-horizontal kak -c %val{session} -e "rename-client tools"
    set global toolsclient tools
    tmux-terminal-vertical kak -c %val{session} -e "rename-client docs"
    set global docsclient docs
    focus main
}
