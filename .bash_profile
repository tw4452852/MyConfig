# .bash_profile

# cache to tmp
export XDG_CACHE_HOME="/tmp/.cache"
mkdir -p "$XDG_CACHE_HOME"
export XDG_RUNTIME_DIR="/tmp/runtime-tw"
mkdir -p "$XDG_RUNTIME_DIR"

# rust
[ -f $HOME/.cargo/env ] && . $HOME/.cargo/env

# Go
[ -f $HOME/.go/env ] && . $HOME/.go/env

# Dart/Flutter
[ -f $HOME/.dart/env ] && . $HOME/.dart/env

# Plan9Port
[ -f $HOME/.p9p/env ] && . $HOME/.p9p/env

# MySelf
export PATH=$PATH:$HOME/MyRoot/bin

# Ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc
