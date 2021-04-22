#!/bin/bash

source 00_settings.sh

# do not rename eth0
karg='net.ifnames=0 biosdevname=0'

# enable apparmor
karg+=' apparmor=1 security=apparmor'

# performance optimization
karg+=' transparent_hugepage=never scsi_mod.use_blk_mq=1'

echo "starting qemu"
if [ "$arch" == "x86_64" ]; then
  qemu-system-x86_64 \
    -enable-kvm \
    -smp cpus=2 \
    -m 2G \
    -kernel output/vmlinuz-$arch \
    -initrd output/initrd-$arch \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
    -vga virtio \
    -append "$karg"
fi

if [ "$arch" == "aarch64" ]; then
  qemu-system-aarch64 \
    -machine virt \
    -machine virtualization=true \
    -cpu cortex-a57 \
    -machine type=virt \
    -smp cpus=2 \
    -m 2G \
    -kernel output/vmlinuz-$arch \
    -initrd output/initrd-$arch \
    -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
    -nographic \
    -append "$karg"
fi

