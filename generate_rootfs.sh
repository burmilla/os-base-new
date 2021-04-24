#!/usr/bin/env bash
set -Eeuo pipefail

arch=$1
debuerreotype_version="0.12"
debian_version="bullseye"
debian_snapshot_timestamp="2021-04-24 08:39:43"
epoch="$(TZ=UTC date --date "$debian_snapshot_timestamp" +%s)"

source .functions.sh

start_debuerreotype

create_rootfs $arch $debian_version $epoch
install_packages $arch
update_configs $arch
add_users $arch
install_busybox $arch
minize_size $arch
package_rootfs $arch

stop_debuerreotype
