arch="amd64"
kernel_version="5.10.31-burmilla"
debian_version="bullseye"
docker_version="20.10.6"
output_version="prototype"

#----
if [ "$arch" == "amd64" ]; then
  kernel_arch="x86"
  docker_arch="x86_64"
fi
