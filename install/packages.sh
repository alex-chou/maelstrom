#!/bin/bash
install_pckg=(              \
    feh                     \
    htop                    \
    i3                      \
    rxvt-unicode-256color   \
    xclip                   \
    zsh                     \
)

for pckg in "${install_pckg[@]}"; do
    echo installing $pckg
    sudo apt-get install $pckg
done

echo finished installing
