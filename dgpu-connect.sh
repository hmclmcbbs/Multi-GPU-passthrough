#!/bin/bash
sudo systemctl stop lactd.service
sudo modprobe -r vfio-pci
sudo modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
sudo systemctl reset-failed nvidia-powerd.service
sudo systemctl restart nvidia-persistenced nvidia-powerd.service lactd.service
echo "Finished"
