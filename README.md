# New OS base for BurmillaOS
This repository contains beta version of scripts which combines [os-kernel](https://github.com/burmilla/os-kernel/) to root file system from debian:bullseye-slim Docker image using [Debuerreotype](https://github.com/debuerreotype/debuerreotype)

Target is provide minimal OS base which run Docker, K3s or RKE2 and also have needed components in-place to support [cgroup v2](https://medium.com/nttlabs/cgroup-v2-596d035be4d7) and [rootless mode](https://docs.docker.com/engine/security/rootless/) and ability to install any standard Debian packages.

It replaces these components totally:
* [os-base](https://github.com/burmilla/os-base)
* [os-initrd-base](https://github.com/burmilla/os-initrd-base)
* [os-system-docker](https://github.com/burmilla/os-system-docker)

# How to test
* Use Linux desktop
* Docker
* Generate rootfs for using commands:
```bash
./generate_rootfs.sh amd64
./generate_rootfs.sh arm64
./generate_rootfs.sh mips64el
```
