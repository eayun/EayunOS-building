# Direct requirements
rubygem-virt-p2v
dejavu-sans-fonts
xorg-x11-xinit
xorg-x11-drivers
xorg-x11-server-Xorg
/usr/bin/setsid

# Boot requirements
device-mapper

# Required for livecd creation
passwd
rpm
/usr/sbin/lokkit

# For useful debugging
vim-minimal
/usr/bin/scp    # For extracting log files
/usr/bin/gzip   # For compressing core files
less
strace

# Remove unnecessary packages
-audit-libs-python
-ustr
-authconfig
-wireless-tools
-setserial
-prelink
-newt-python
-newt
-libselinux-python
-kbd
-usermode
-fedora-release
-fedora-release-notes
-dmraid
-which
-parted
-tar
-libuser
-mtools
-cpio
-yum
-numactl # Pulls in perl dependency
-perl

# qlogic firmware
ql2100-firmware
ql2200-firmware
ql23xx-firmware
ql2400-firmware
ql2500-firmware
