Recently, after tossing through dual graphics cards, I feel that it is very incongruous to restart every time I switch graphics cards, so I thought of a way to achieve multi-graphics card pass-through without restarting.  


## Native configuration  


The notebook is the 2024 mechanical revolution Aurora X i7-12800HX RTX4060 uses shorin's DMS niri configuration, and the main thing that affects the pass-through is lact (managed graphics card overclocking).  


## Configure the host machine  


### Turn on IOMMU (omitted)  


### Set up VFIO  


Modify /etc/mkinitcpio.conf  
```
  MODULES=(vfio_pci vfio vfio_iommu_type1)'
```
Isolate the GPU  
```
  sudo vim /etc/modprobe.d/vfio.conf
```
write  
```
  options vfio-pci ids="own hardware id" (separated by a comma between the hardware id and the hardware id)
```
Regenerate initramfs  
Install and configure the OVMF
```
  sudo pacman -S --needed edk2-ovmf
```
Edit the profile  
```
  sudo vim /etc/libvirt/qemu.conf
```
Search for nvram, write where appropriate:  
```
  nvram = [  
  	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"  
  ]  
```
  
## Configure virtual machine (just add the hardware you want to pass through)  


# Key steps  


1. Put the script in the directory into the directory of your own settings (mine is placed in the $HOME directory)  
2. Create a new systemd system-level service to boot up and execute dgpu-disconnect.sh scripts  
3. In the debug settings of niri, join  
```
  ignore-drm-device "/dev/dri/'/dev/dri/by-path//corresponding card0/1/2/3...'"  
  ignore-drm-device "/dev/dri/'/dev/dri/by-path/ corresponding to renderD128/D129...'"
```
4. If you want to have leftovers, you can customize the command and bind these two scripts to facilitate execution.  
### So, you can switch graphics cards without restarting, and you can easily connect the graphics card directly to the physical machine or virtual machine  
# Precautions  
1. Before the graphics card goes directly to the virtual machine, run nvidia-smi, lsof /dev/nvidia*, check whether there is a process residue, if there is, remember to kill it to prevent the system from getting stuck.  
2. Before doing everything, run "" sudo lsof -n -w /dev/nvidia* "" to change all the services displayed into the two scripts in the directory to make sure the scripts are working properly.  
3. After executing the script, you can check whether the graphics card is handed over to VFIO through the following command:
```
  sudo dmesg | grep -i vfio
```
If something like the following appears, it is a success:
```
  [  170.607580] vfio-pci 0000:01:00.0: vgaarb: VGA decodes changed: olddecodes=none,decodes=io+mem:owns=none  
  [  170.607741] vfio_pci: add [10de:28e0[ffffffff:ffffffff]] class 0x000000/00000000
```
