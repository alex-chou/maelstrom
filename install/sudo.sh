#!/bin/bash

################
# install sudo #
################
echo 'installing sudo now'
apt-get install sudo

read -p 'which user would you like to add to sudo? ' username
sudo adduser $username sudo
