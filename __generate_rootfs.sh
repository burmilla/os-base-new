#!/usr/bin/env bash
set -Eeuo pipefail

source .settings.sh
source .functions.sh

# start_debuerreotype

# create_rootfs amd64 $debian_version $epoch
# create_rootfs arm64 $debian_version $debian_snapshot_timestamp
# create_rootfs mips64el $debian_version $debian_snapshot_timestamp

# install_packages amd64
# install_packages arm64
# install_packages mips64el

# update_configs amd64
# update_configs arm64
# update_configs mips64el

add_users amd64
add_users arm64
add_users mips64el

### TODO: Cleanups...
# debuerreotype-slimify
# chroot rootfs sh -c 'rm -rf /var/lib/apt/lists/*'

# stop_debuerreotype
