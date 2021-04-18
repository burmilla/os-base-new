#!/bin/bash
set -e

arch=x86_64
version=20.10.6

mkdir -p download
mkdir -p docker
rm -rf docker/*
curl -L -o download/docker-$arch.tar.gz https://download.docker.com/linux/static/stable/$arch/docker-$version.tgz
tar -zxf download/docker-$arch.tar.gz -C .

curl -L -o download/docker-bash-completion https://raw.githubusercontent.com/docker/cli/v$version/contrib/completion/bash/docker

