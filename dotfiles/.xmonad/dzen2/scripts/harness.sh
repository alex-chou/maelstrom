#!/bin/sh

FONT=-*-terminus-medium-*-*-*-*-120-72-72-*-*-iso10646-*
FONT=-misc-tamsyn-medium-r-normal--13-94-100-100-c-70-iso8859-1
FONT=-misc-tamsyn-medium-r-normal--12-87-100-100-c-60-iso8859-1

zsh statusbar.sh | dzen2 -e - -x '512' -y '384' -h '16' -w '600' -ta r -fg '#ffffff' -bg '#161616' -fn "$FONT"
