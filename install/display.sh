#!/bin/bash
# install xorg (startx command) and i3 (window manager)

echo 'getting xorg'
sudo apt-get install xorg

echo 'getting i3'
sudo apt-get install i3

echo 'running startx'
startx
