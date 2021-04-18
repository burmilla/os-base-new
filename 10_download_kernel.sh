#!/bin/bash
set -e

arch=x86
version=5.10.28-burmilla

mkdir -p download
mkdir -p kernel
rm -rf kernel/*
curl -L -o download/linux-$arch.tar.gz https://github.com/burmilla/os-kernel/releases/download/v$version/linux-$version-$arch.tar.gz
tar -zxf download/linux-x86.tar.gz -C kernel/

