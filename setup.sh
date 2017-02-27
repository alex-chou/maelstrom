#!/bin/bash

BASE=`dirname $(readlink -f "$0")`
echo $BASE
DOTFILES=$BASE/dotfiles

#############
# SETUP GIT #
#############
git config --global core.excludesfile dotfiles/.gitignore_global
git config --global color.ui true
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.scrub "!git ls-files --deleted -z | xargs -0 git rm"

git config --global user.name "alex-chou"
git config --global user.email "chou.alexander@gmail.com"


######################
## LINK CONFIG FILES #
######################

dotfiles=(    \
.bashrc       \
.bash_profile \
.colors       \
.fehbg        \
.poweroff     \
.startup      \
.vimrc        \
.Xdefaults    \
.xinitrc      \
.zprofile     \
.zshrc        \
)

dotdirs=(     \
.colors       \
.i3           \
.ssh          \
.vim          \
.wallpapers   \
)

BACKUP=$BASE/backups
mkdir -p $BACKUP

for df in "${dotfiles[@]}"; do
    if [ -e ~/$df ]; then
        if [ -L ~/$df ]; then
            echo Removing link \[ $dd \-\> $(readlink ~/$dd) \]
            rm -f ~/$df
        else 
            echo $df moved to $BACKUP
            mv -f ~/$df $BACKUP
        fi
    fi

    echo Linking $df
    ln -s $DOTFILES/$df ~/$df
done

for dd in "${dotdirs[@]}"; do
    if [ -e ~/$dd ]; then
        if [ -L ~/$dd ]; then
            echo Removing link \[ $dd \-\> $(readlink ~/$dd) \]
            rm -f ~/$dd
        else 
            echo $dd moved to $BACKUP
            mv -f ~/$dd $BACKUP
        fi
    fi

    echo Soft linking directory $dd
    ln -s $DOTFILES/$dd ~/$dd
done
