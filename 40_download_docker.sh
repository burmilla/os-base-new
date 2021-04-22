#!/bin/bash
set -e

source 00_settings.sh

mkdir -p download
mkdir -p docker
rm -rf docker/*
curl -L -o download/docker-$docker_arch.tar.gz https://download.docker.com/linux/static/stable/$docker_arch/docker-$docker_version.tgz
tar -zxf download/docker-$docker_arch.tar.gz -C .

curl -L -o download/docker-bash-completion https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/bash/docker

