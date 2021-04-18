#!/bin/bash

mkdir -p output
rm -rf output/*
cp kernel/boot/vmlinuz-* output/vmlinuz

pushd rootfs/
find | cpio -H newc -o | gzip -1 > ../output/initrd
popd

qemu-system-x86_64 -m 1G -kernel output/vmlinuz -initrd output/initrd -nic user,model=virtio-net-pci

