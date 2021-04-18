#!/bin/bash
set -e

cp -rp docker/* rootfs/usr/local/bin/

curl -L -o rootfs/etc/init.d/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/engine/contrib/init/sysvinit-debian/docker
chmod 0755 rootfs/etc/init.d/docker

curl -L -o rootfs/etc/default/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/engine/contrib/init/sysvinit-debian/docker.default
sed -i -e 's/#DOCKERD=/DOCKERD=/' rootfs/etc/default/docker

mkdir -p rootfs/etc/bash_completion.d
cp download/docker-bash-completion rootfs/etc/bash_completion.d/docker

