#!/bin/bash
set -e

arch=amd64
version=bullseye

mkdir -p rootfs
rm -rf rootfs/*
curl -L -o download/rootfs-$arch.tar.xz "https://github.com/debuerreotype/docker-debian-artifacts/blob/dist-$arch/$version/slim/rootfs.tar.xz?raw=true"
tar -Jxf download/rootfs-$arch.tar.xz -C rootfs/

