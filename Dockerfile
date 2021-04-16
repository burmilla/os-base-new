FROM	ubuntu
ARG	buildroot=2021.02.1
RUN	apt-get update \
	&& apt-get install -y build-essential curl dialog ncurses-base ncurses-bin libncurses5-dev libelf-dev libssl-dev
RUN	mkdir -p /src/ \
	&& curl -L -o /tmp/buildroot.tar.gz https://buildroot.org/downloads/buildroot-${buildroot}.tar.gz \
	&& tar -zxvf /tmp/buildroot.tar.gz -C /src/
WORKDIR /src/buildroot-${buildroot}

ARG	arch=amd64
COPY	config/${arch}/buildroot.config .config
COPY	config/${arch}/kernel.config .
RUN	make

