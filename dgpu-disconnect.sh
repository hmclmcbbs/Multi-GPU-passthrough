#!/bin/bash
sudo systemctl stop nvidia-persistenced nvidia-powerd.service lactd.service
sudo rmmod -f nvidia_drm nvidia_modeset nvidia_uvm nvidia
sudo modprobe vfio-pci ids=10de:28a0,10de:22be
sudo systemctl restart lactd.service
