#!/bin/bash

prompt() {
    if [[ "$2" != "" ]]; then
        info="\n$(echo "$2" | fold -s -w 80 | sed 's/^/    /')\n"
    else
        info=" "
    fi
    echo -e "\033[1;31m\n==========================================================================================\n
    $1\n\033[0m$info\n"
}

uninstall_Nvidia() {
    #uninstall nvidia
    prompt "Uninstall the NVIDIA driver?" "If you are upgrading from a NVIDIA GPU we recommend removing the old NVIDIA driver."
    sudo pacman -R --needed nvidia nvidia-hook nvidia-inst lib32-nvidia-utils
}

install_3D() {
    # install gaming components 
    prompt "Install components used for 3D Applications?" "This includes driver and APIs normally needed for Games"
    sudo pacman -S mesa vulkan-radeon 
    # install 32bit gaming components
    prompt "Install 32bit components used for 3D Applications?" "32bit driver and APIs normally needed for 32bit Games"
    sudo pacman -S lib32-mesa lib32-vulkan-radeon
}

install_VideoRender() {
    # install video encode/decode components
    prompt "Install components used for Hardware accelerated video?" "This includes driver for the VPU use by video player and editing software"
    sudo pacman -S libva-mesa-driver mesa-vdpau
    # install 32bit video encode/decode components
    prompt "Install 32bit components used for Hardware accelerated video?" "32bit driver for the VPU use by video player and editing software"
    sudo pacman -S lib32-libva-mesa-driver lib32-mesa-vdpau
    #Add the current user to render group
    setUserGroup $USER
}

install_OpenCL() {
    # install OpenCL components
    prompt "Install components used for OpenCL?" "Includes drivers for GPU compute, this is usually needed video editing, 3D rendering, and hashing. Not normally needed for gaming or normal desktop use."
    sudo pacman -S rocm-opencl-runtime hip-runtime-amd
    #Add the current user to render group
    setUserGroup $USER
}

install_CUDATranslation() {
    # install experimental CUDA translation layer
    prompt "Install ZLUDA, an unstable CUDA translation layer?" "This is not normally recommended. Most application support HIP and ZLUDA requires some tinkering has limited usability."
    yay -S zluda
}

setUserGroup() {
    echo -e "Adding $1 to 'video' and 'render' group."
    sudo usermod -a -G video $1 && sudo usermod -a -G render $1
}

# update System
prompt "Install system updates?"
sudo pacman -Syuu
# install base driver extra
prompt "Install extra components for X.org?" "This is not strictly needed if you use Wayland but it is recommended for xwayland and for x11 fallback."
sudo pacman -S xf86-video-amdgpu 

if [[ "$1" == "--remove-nvidia" || "$2" == "--remove-nvidia" ]]; then
    uninstall_Nvidia
fi
install_3D
install_VideoRender
install_OpenCL
if [[ "$1" == "--install-zluda" || "$2" == "--install-zluda" ]]; then
    install_CUDATranslation
fi

prompt "A Reboot is recommended"
