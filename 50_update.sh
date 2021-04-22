#!/bin/bash

source 00_settings.sh

mkdir -p output
rm -rf output/*
cp kernel/boot/vmlinuz-* output/vmlinuz-$arch

echo "generating initrd"
pushd rootfs/
find | cpio -H newc -o | gzip -1 > ../output/initrd-$arch
popd

