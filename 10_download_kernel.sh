#!/bin/bash
set -e

source 00_settings.sh

mkdir -p download
mkdir -p kernel
rm -rf kernel/*
curl -L -o download/linux-$kernel_arch.tar.gz https://github.com/burmilla/os-kernel/releases/download/v$kernel_version/linux-$kernel_version-$kernel_arch.tar.gz
tar -zxf download/linux-$kernel_arch.tar.gz -C kernel/

