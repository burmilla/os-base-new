#!/bin/bash
set -e

cp fstab rootfs/etc/
cp init rootfs/
rm -rf rootfs/run/*

chroot rootfs sh -c 'apt-get update && apt-get install -y iputils-ping net-tools kmod sysvinit-core udev udhcpc'
chroot rootfs /bin/busybox --install -s

chroot rootfs sh -c 'echo > /etc/motd'
chroot rootfs sh -c 'echo "burmilla" > /etc/hostname'


# TODO: Add rancher users, etc...
# ...

# FixMe: We shouldn't hardcode password here
#chroot rootfs sh -c 'echo "rancher:rancher" | chpasswd'

# FixMe: We shouldn't use root user
chroot rootfs sh -c 'echo "root:root"|chpasswd'


cp -rp kernel/lib/firmware/ rootfs/lib/
cp -rp kernel/lib/modules/ rootfs/lib/
depmod -b rootfs $(basename rootfs/lib/modules/*)

