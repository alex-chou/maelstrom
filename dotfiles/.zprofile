export PATH=$PATH:/sbin:$HOME/.cabal/bin
export EDITOR=vim
[[ -z $DISPLAY && $(tty) = /dev/tty1 ]] && startx
