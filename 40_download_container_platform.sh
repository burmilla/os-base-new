#!/bin/bash
set -e

source 00_settings.sh
mkdir -p download

if [ "$container_platform" == "docker" ]; then
  mkdir -p docker
  rm -rf docker/*
  curl -L -o download/docker-$docker_arch.tar.gz https://download.docker.com/linux/static/stable/$docker_arch/docker-$docker_version.tgz
  tar -zxf download/docker-$docker_arch.tar.gz -C .
  curl -L -o download/docker-bash-completion https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/bash/docker
fi

if [ "$container_platform" == "k3s" ]; then
  url="https://github.com/k3s-io/k3s/releases/download/$k3s_version/k3s"
  if [ "$docker_arch" != "x86_64" ]; then
    url+="_$docker_arch"
  fi
  curl -L -o download/k3s-$docker_arch $url
fi

