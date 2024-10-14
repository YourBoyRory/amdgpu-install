#!/bin/bash

echo $1
echo $2

# update System
sudo pacman -Syuu

if [[ "$1" == "--remove-nvidia" || "$2" == "--remove-nvidia" ]]; then
    #uninstall nvidia
    sudo pacman -R nvidia nvidia-hook nvidia-inst lib32-nvidia-utils
fi
#install AMD
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau rocm-opencl-runtime
if [[ "$1" == "--install-zluda" || "$2" == "--install-zluda" ]]; then
    # install experemental cuda support for AMD
    yay -S zluda
fi
sudo dracut-rebuild
