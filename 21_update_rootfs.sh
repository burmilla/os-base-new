#!/bin/bash
set -e

source 00_settings.sh

mkdir -p rootfs
rm -rf rootfs/*
tar -Jxf download/rootfs-$arch.tar.xz -C rootfs/

cp files/fstab rootfs/etc/
cp files/init rootfs/
cp files/rc.local rootfs/etc/
cp files/sysctl.conf rootfs/etc/
rm -rf rootfs/run/*

# include needed tools:
echo 'apt::install-recommends "false";' > rootfs/etc/apt/apt.conf.d/no-install-recommends
chroot rootfs sh -c 'apt-get update && apt-get install -y apparmor bash-completion ca-certificates iptables iputils-ping locales logrotate net-tools kmod open-iscsi openssh-server sudo syslog-ng-core sysvinit-core udhcpc'

# TODO: Figure out if we need udev or not? Or devtmpfs on kernel enough for us?

cp files/iscsid.conf rootfs/etc/iscsi/
cp files/sshd_config rootfs/etc/ssh/sshd_config
cat > rootfs/etc/lsb-release << EOF
DISTRIB_ID=BurmillaOS
DISTRIB_RELEASE=${output_version}
DISTRIB_DESCRIPTION="BurmillaOS ${output_version}"
EOF

# optimize size
echo 'en_US.UTF-8 UTF-8' > rootfs/etc/locale.gen
find rootfs/usr/share/i18n/charmaps -not -path rootfs/usr/share/i18n/charmaps/UTF-8.gz -name '*.gz' -exec rm -rf {} \;
find rootfs/usr/share/i18n/locales -not -path rootfs/usr/share/i18n/locales/en_US -name '*_*' -exec rm -rf {} \;
chroot rootfs locale-gen
chroot rootfs sh -c 'rm -rf /var/lib/apt/lists/*'

# use busybox for everything where do not have separate tools
chroot rootfs /bin/busybox --install -s
chmod +s rootfs/bin/ping
echo > rootfs/etc/motd
echo > rootfs/etc/issue.net
cp files/issue rootfs/etc/issue
echo "burmilla" > rootfs/etc/hostname

# add needed users and groups
chroot rootfs addgroup --gid 1100 rancher
chroot rootfs addgroup --gid 1101 docker
chroot rootfs useradd -u 1100 -g rancher -G docker,sudo -m -s /bin/bash rancher
chroot rootfs useradd -u 1101 -g docker -G docker,sudo -m -s /bin/bash docker
echo '## allow password less for rancher user' >> rootfs/etc/sudoers
echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> rootfs/etc/sudoers
echo '## allow password less for docker user' >> rootfs/etc/sudoers
echo 'docker ALL=(ALL) NOPASSWD: ALL' >> rootfs/etc/sudoers

# FixMe: We shouldn't hardcode password here
chroot rootfs sh -c 'echo "rancher:rancher" | chpasswd'

# preperation for https://docs.docker.com/engine/security/userns-remap/
chroot rootfs addgroup --gid 1200 user-docker
chroot rootfs adduser --system -u 1200 --gid 1200 --disabled-login --no-create-home user-docker
echo 'user-docker:100000:65536' > rootfs/etc/subuid
echo 'user-docker:100000:65536' > rootfs/etc/subgid

# include firmwares and kernel modules
cp -rp kernel/lib/firmware/ rootfs/lib/
cp -rp kernel/lib/modules/ rootfs/lib/
depmod -b rootfs $(basename rootfs/lib/modules/*)

echo "rootfs updated"

