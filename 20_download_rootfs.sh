#!/bin/bash
set -e

source 00_settings.sh

curl -L -o download/rootfs-$arch.tar.xz "https://github.com/debuerreotype/docker-debian-artifacts/blob/dist-$arch/$debian_version/slim/rootfs.tar.xz?raw=true"

