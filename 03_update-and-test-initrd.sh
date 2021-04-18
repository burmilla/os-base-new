#!/bin/bash

rm output/initrd
pushd debian-rootfs/
find | cpio -H newc -o | gzip -1 > ../output/initrd
popd

qemu-system-x86_64 -m 1G -kernel output/vmlinuz -initrd output/initrd -nic user,model=virtio-net-pci
# -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22

