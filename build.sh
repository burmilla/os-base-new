#!/bin/bash
set -e

USAGE="Usage: ./build.sh <version>"
if [ "$#" -lt "1" ]; then
    echo $USAGE
    exit 0
fi
VERSION=$1

docker build . -t burmilla/elemental-prototype:$VERSION
docker push burmilla/elemental-prototype:$VERSION
mkdir -p output
docker run --rm -ti \
    -v $(pwd)/output:/output \
    ghcr.io/rancher/elemental-toolkit/elemental-cli:v2.2.0 \
    --debug build-iso \
    --bootloader-in-rootfs \
    -o ./output burmilla/elemental-prototype:$VERSION
