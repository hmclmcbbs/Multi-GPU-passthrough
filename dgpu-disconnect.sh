#!/bin/bash
sudo fuser -k -9 /dev/nvidia*
sudo fuser -k -9 /dev/dri/renderD129
sudo fuser -k -9 /dev/dri/renderD129
sudo fuser -k -9 /dev/dri/renderD129
sudo fuser -k -9 /dev/dri/card0
sudo fuser -k -9 /dev/dri/card0
sudo fuser -k -9 /dev/dri/card0
sudo systemctl stop nvidia-persistenced nvidia-powerd.service lactd.service
sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia
sudo modprobe vfio-pci ids=10de:28a0,10de:22be
sudo systemctl restart lactd.service
echo "Finished"
