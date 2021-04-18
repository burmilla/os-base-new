#!/bin/bash
set -e

arch=amd64
version=bullseye

curl -L -o download/rootfs-$arch.tar.xz "https://github.com/debuerreotype/docker-debian-artifacts/blob/dist-$arch/$version/slim/rootfs.tar.xz?raw=true"

