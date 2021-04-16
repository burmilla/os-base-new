#!/usr/bin/env bash

start_debuerreotype() {
    workdir=$(dirname $(readlink -f $0))
    docker run \
    --detach=true \
    --cap-add SYS_ADMIN \
    --cap-drop SETFCAP \
    --security-opt apparmor=unconfined \
    --security-opt seccomp=unconfined \
    --tmpfs /tmp:dev,exec,suid,noatime \
    --env TMPDIR=/tmp \
    --workdir /workdir \
    --name debuerreotype \
    -v $workdir:/workdir \
    debuerreotype/debuerreotype:0.12 \
    sleep infinity
}

stop_debuerreotype() {
    docker stop debuerreotype
    docker rm debuerreotype
}

create_rootfs() {
    arch=$1
    debian_version=$2
    epoch=$3
    workdir=$(dirname $(readlink -f $0))
    docker exec -i debuerreotype sh -euxc "debuerreotype-init --arch=$arch '/workdir/rootfs_$arch' '$debian_version' '@$epoch'"
    echo 'APT::Install-Suggests="true";'> $workdir/rootfs_$arch/etc/apt/apt.conf.d/90norecommends
    docker exec -i debuerreotype sh -euxc "debuerreotype-minimizing-config '/workdir/rootfs_$arch'"
    docker exec -i debuerreotype sh -euxc "debuerreotype-apt-get '/workdir/rootfs_$arch' update -qq"
    docker exec -i debuerreotype sh -euxc "debuerreotype-apt-get '/workdir/rootfs_$arch' dist-upgrade -yqq"
}

install_packages() {
    arch=$1
    packages=(
        apparmor
        bash-completion
        ca-certificates
        cloud-init
        iptables
        iputils-ping
        logrotate
        net-tools
        kmod
        open-iscsi
        openssh-server
        sudo
        syslog-ng-core
        sysvinit-core
        udhcpc
    )
    docker exec -i debuerreotype sh -euxc "debuerreotype-apt-get '/workdir/rootfs_$arch' install -y -qq ${packages[*]}"
}

update_configs() {
    arch=$1
    workdir=$(dirname $(readlink -f $0))
    cp "$workdir/files/fstab" "$workdir/rootfs_$arch/etc/"
    cp "$workdir/files/init" "$workdir/rootfs_$arch/"
    cp "$workdir/files/rc.local" "$workdir/rootfs_$arch/etc/"
    cp "$workdir/files/sysctl.conf" "$workdir/rootfs_$arch/etc/"
    cp "$workdir/files/iscsid.conf" "$workdir/rootfs_$arch/etc/iscsi/"
    cp "$workdir/files/sshd_config" "$workdir/rootfs_$arch/etc/ssh/sshd_config"
    rm "$workdir/rootfs_$arch/etc/os-release"
    echo > "$workdir/rootfs_$arch/etc/motd"
    echo > "$workdir/rootfs_$arch/etc/issue.net"
    cp "$workdir/files/issue" "$workdir/rootfs_$arch/etc/issue"
    echo "burmilla" > "$workdir/rootfs_$arch/etc/hostname"
}

add_users() {
    arch=$1
    workdir=$(dirname $(readlink -f $0))
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' addgroup --gid 1100 rancher"
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' addgroup --gid 1101 docker"
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' useradd -u 1100 -g rancher -G docker,sudo -m -s /bin/bash rancher"
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' useradd -u 1101 -g docker -G docker,sudo -m -s /bin/bash docker"
    echo '## allow password less for rancher user' >> "$workdir/rootfs_$arch/etc/sudoers"
    echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> "$workdir/rootfs_$arch/etc/sudoers"
    echo '## allow password less for docker user' >> "$workdir/rootfs_$arch/etc/sudoers"
    echo 'docker ALL=(ALL) NOPASSWD: ALL' >> "$workdir/rootfs_$arch/etc/sudoers"

    # preperation for https://docs.docker.com/engine/security/userns-remap/
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' addgroup --gid 1200 user-docker"
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' adduser --system -u 1200 --gid 1200 --disabled-login --no-create-home user-docker"
    echo 'user-docker:100000:65536' > "$workdir/rootfs_$arch/etc/subuid"
    echo 'user-docker:100000:65536' > "$workdir/rootfs_$arch/etc/subgid"

    # FixMe: We shouldn't hardcode password here
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' sh -euxc 'echo \"rancher:rancher\" | chpasswd'"
}

install_busybox() {
    arch=$1
    workdir=$(dirname $(readlink -f $0))
    docker exec -i debuerreotype sh -euxc "debuerreotype-chroot '/workdir/rootfs_$arch' /bin/busybox --install -s"
    chmod +s "$workdir/rootfs_$arch/bin/ping"
}

minize_size() {
    arch=$1
    workdir=$(dirname $(readlink -f $0))
    docker exec -i debuerreotype sh -euxc "debuerreotype-slimify '/workdir/rootfs_$arch'"
    rm -rf "$workdir/rootfs_$arch/var/lib/apt/lists/*"
}

package_rootfs() {
    arch=$1
    workdir=$(dirname $(readlink -f $0))
    mkdir -p "$workdir/output"
    tar -I 'zstd --ultra -22' -cf "$workdir/output/rootfs_amd64.tar.zst" rootfs_$arch
}
