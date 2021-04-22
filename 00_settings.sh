arch=$(arch)
kernel_version="5.10.31-burmilla"
debian_version="bullseye"
docker_version="20.10.6"
k3s_version="v1.20.6+k3s1"
output_version="prototype"

# Docker / K3s selection
container_platform="docker"
# container_platform="k3s"


if [ "$arch" == "x86_64" ]; then
  debian_arch="amd64"
  docker_arch="x86_64"
  kernel_arch="x86"
fi

if [ "$arch" == "aarch64" ]; then
  debian_arch="arm64v8"
  docker_arch="aarch64"
  kernel_arch="arm64"
fi

