FROM	ubuntu
ARG	buildroot=2021.02.1

RUN	apt-get update \
	&& apt-get install -y bc build-essential curl cpio dialog \
	gcc-10 git ncurses-base ncurses-bin libncurses5-dev libelf-dev \
	libssl-dev python3 rsync unzip wget

RUN	curl -L -o /tmp/buildroot.tar.gz https://buildroot.org/downloads/buildroot-${buildroot}.tar.gz \
	&& tar -zxf /tmp/buildroot.tar.gz -C / \
	&& cd / \
	&& mv buildroot-${buildroot} buildroot \
	&& rm -f /tmp/buildroot.tar.gz

WORKDIR /buildroot
ARG	arch=amd64
COPY	config/${arch}/buildroot.config .config
COPY	config/${arch}/kernel.config .

#ENTRYPOINT make

