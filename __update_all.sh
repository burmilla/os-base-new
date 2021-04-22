#!/bin/bash
set -e

./10_download_kernel.sh
./20_download_rootfs.sh
./21_update_rootfs.sh
./40_download_docker.sh
./41_update_docker.sh
./50_update.sh
./51_test.sh

