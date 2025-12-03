# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function _in_container {
  [ -n "${CONTAINER_ID}" ] && echo "in container ${CONTAINER_ID} "
}
PS1="[\u $(_in_container)\w]\$ "

export EDITOR=kak
