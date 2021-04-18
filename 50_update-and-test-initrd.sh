#!/bin/bash

mkdir -p output
rm -rf output/*
cp kernel/boot/vmlinuz-* output/vmlinuz

echo "generating initrd"
pushd rootfs/
find | cpio -H newc -o | gzip -1 > ../output/initrd
popd

# do not rename eth0
karg='net.ifnames=0 biosdevname=0'

echo "starting qemu"
qemu-system-x86_64 -enable-kvm -smp cpus=2 -m 2G -kernel output/vmlinuz -initrd output/initrd -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 -vga virtio -append "$karg"

