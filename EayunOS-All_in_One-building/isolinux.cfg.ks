default vesamenu.c32
#prompt 1
timeout 600

display boot.msg

menu background splash.jpg
menu title Welcome to eayunOS 4.0!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000

label ks-all_in_one
  menu default
  menu label ^(Automatic) All in One Installation
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks/eayunOS-all_in_one.cfg
label ks-management_only
  menu label ^(Automatic) Management_Only Installation
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks/eayunOS-management_only.cfg
label ks-node_only
  menu label ^(Automatic) Node_Only Installation
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks/eayunOS-node_only.cfg
label linux
  menu label ^Install or upgrade an existing system
  kernel vmlinuz
  append initrd=initrd.img
label vesa
  menu label Install system with ^basic video driver
  kernel vmlinuz
  append initrd=initrd.img xdriver=vesa nomodeset
label rescue
  menu label ^Rescue installed system
  kernel vmlinuz
  append initrd=initrd.img rescue
label local
  menu label Boot from ^local drive
  localboot 0xffff
label memtest86
  menu label ^Memory test
  kernel memtest
  append -

