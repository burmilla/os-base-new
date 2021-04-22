#!/bin/bash
set -e

source 00_settings.sh

if [ "$container_platform" == "docker" ]; then
  cp -rp docker/* rootfs/usr/local/bin/

  curl -L -o rootfs/etc/init.d/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/engine/contrib/init/sysvinit-debian/docker
  chmod 0755 rootfs/etc/init.d/docker

  curl -L -o rootfs/etc/default/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/engine/contrib/init/sysvinit-debian/docker.default
  sed -i -e 's/#DOCKERD=/DOCKERD=/' rootfs/etc/default/docker
  echo 'export DOCKER_RAMDISK=true' >> rootfs/etc/default/docker

  mkdir -p rootfs/etc/bash_completion.d
  cp download/docker-bash-completion rootfs/etc/bash_completion.d/docker

  chroot rootfs update-rc.d docker defaults
fi

if [ "$container_platform" == "k3s" ]; then
  cp download/k3s-$docker_arch rootfs/usr/local/bin/k3s
  chmod 0755 rootfs/usr/local/bin/k3s
fi

