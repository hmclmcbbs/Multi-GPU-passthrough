最近折腾完双显卡直通，感觉每次切换显卡都要重启一次很违和，故想到了不重启实现多显卡直通的方法。
##本机配置
笔记本是2024年机械革命的极光X i7-12800HX RTX4060 用的是shorin的DMS niri配置，影响直通的主要是lact(管理显卡超频)。
##配置宿主机
###开启IOMMU(省略)
###设置VFIO
修改 /etc/mkinitcpio.conf
  MODULES=(vfio_pci vfio vfio_iommu_type1)'
隔离GPU
  sudo vim /etc/modprobe.d/vfio.conf
写入
  options vfio-pci ids="自己的硬件id" (硬件id与硬件id之间用英文逗号隔开）
重新生成 Initramfs 
安装和配置ovmf
  sudo pacman -S --needed edk2-ovmf
编辑配置文件
  sudo vim /etc/libvirt/qemu.conf
搜索nvram，在合适的地方写入：
  nvram = [
  	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
  ]
##配置虚拟机(加入自己要直通的硬件即可)
#重点步骤
1.将目录中的脚本放入自己的设置的目录(我的放在$HOME目录)
2.新建systemd系统级服务，用于开机执行dgpu-disconnect.sh脚本
3.在niri的debug设置中,加入
  ignore-drm-device "/dev/dri/'/dev/dri/by-path/中独显对应card0/1/2/3...'"
  ignore-drm-device "/dev/dri/'/dev/dri/by-path/中独显对应renderD128/D129...'"
4.想剩事的话可以自定义指令，绑定这两个脚本，方便执行。
###这样，便可以实现无重启切换显卡，随便将显卡直通到实体机或虚拟机
#注意事项
1.在显卡直通到虚拟机之前，要先运行nvidia-smi,lsof /dev/nvidia*,检查是否有进程残余,若有，记得杀死，防止系统卡死.
2.在进行所有操作之前，先运行sudo lsof -n -w  /dev/nvidia*,将显示的所有服务更改到目录的两个脚本中，确保脚本正常进行.
3.执行完脚本，可以通过下面的指令查看显卡是否成果交给 VFIO：
  sudo dmesg | grep -i vfio
如果出现类似下面的信息，即为成功：
  [  170.607580] vfio-pci 0000:01:00.0: vgaarb: VGA decodes changed: olddecodes=none,decodes=io+mem:owns=none
  [  170.607741] vfio_pci: add [10de:28e0[ffffffff:ffffffff]] class 0x000000/00000000
