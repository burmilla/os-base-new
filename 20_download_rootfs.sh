#!/bin/bash
set -e

source 00_settings.sh

curl -L -o download/rootfs-$debian_arch.tar.xz "https://github.com/debuerreotype/docker-debian-artifacts/blob/dist-$debian_arch/$debian_version/slim/rootfs.tar.xz?raw=true"

