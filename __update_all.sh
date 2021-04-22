#!/bin/bash
set -e

./10_download_kernel.sh
./20_download_rootfs.sh
./21_update_rootfs.sh
./40_download_container_platform.sh
./41_update_container_platform.sh
./50_update.sh
./51_test.sh

