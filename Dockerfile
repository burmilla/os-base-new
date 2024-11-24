FROM ghcr.io/rancher/elemental-toolkit/elemental-cli:v2.2.0 AS toolkit

FROM debian:bookworm-slim

# Skipped for now: apparmor nfs-common open-iscsi
# sysvinit-core because maybe not needed?
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    cloud-init \
    curl \
    eject \
    fdisk \
    ipset \
    iptables \
    iproute2 \
    iputils-ping \
    locales \
    logrotate \
    net-tools \
    nvi \
    kmod \
    openssh-server \
    psmisc \
    sudo \
    syslog-ng-core \
    udhcpc \
    xz-utils \
    \
    && update-alternatives --set iptables /usr/sbin/iptables-legacy \
    && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/ssh/*key*

# TODO: SSH and iSCSI configs
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
    && locale-gen \
    && find /usr/share/i18n/charmaps -not -path /usr/share/i18n/charmaps/UTF-8.gz -name '*.gz' -exec rm -rf {} \; \
    && find /usr/share/i18n/locales -not -path /usr/share/i18n/locales/en_US -name '*_*' -exec rm -rf {} \; \
    && addgroup --gid 1100 rancher \
    && addgroup --gid 1101 docker \
    && useradd -u 1100 -g rancher -G docker,sudo -m -s /bin/bash rancher \
    && useradd -u 1101 -g docker -G docker,sudo -m -s /bin/bash docker \
    && echo '## allow password less for rancher user' >> /etc/sudoers \
    && echo 'rancher ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo '## allow password less for docker user' >> /etc/sudoers \
    && echo 'docker ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo > /etc/motd \
    && addgroup --gid 1200 user-docker \
    && adduser --system -u 1200 --gid 1200 --disabled-login --no-create-home user-docker

# Packages needed by elemental-toolkit
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    dracut \
    grub2 \
    grub-efi-amd64-signed \
    linux-image-amd64 \
    shim-signed \
    systemd \
    systemd-sysv \
    && rm -rf /var/lib/apt/lists/*


# Hack to prevent systemd-firstboot failures while setting keymap, this is known
# Debian issue (T_T) https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=790955
ARG KBD=2.6.4
RUN curl -L https://mirrors.edge.kernel.org/pub/linux/utils/kbd/kbd-${KBD}.tar.xz --output kbd-${KBD}.tar.xz && \
    tar xaf kbd-${KBD}.tar.xz && mkdir -p /usr/share/keymaps && cp -Rp kbd-${KBD}/data/keymaps/* /usr/share/keymaps/

# Symlink grub2-editenv
RUN ln -sf /usr/bin/grub-editenv /usr/bin/grub2-editenv

# Just add the elemental cli
COPY --from=toolkit /usr/bin/elemental /usr/bin/elemental

# Enable essential services
RUN systemctl enable systemd-networkd.service

# Enable /tmp to be on tmpfs
RUN cp /usr/share/systemd/tmp.mount /etc/systemd/system

# Generate en_US.UTF-8 locale, this the locale set at boot by
# the default cloud-init
RUN locale-gen --lang en_US.UTF-8

# Add default snapshotter setup
#ADD snapshotter.yaml /etc/elemental/config.d/snapshotter.yaml

# Generate initrd with required elemental services
RUN elemental --debug init -f

# Adding specific network configuration based on netplan
#ADD 05_network.yaml /system/oem/05_network.yaml

# Arrange bootloader binaries into /usr/lib/elemental/bootloader
# this way elemental installer can easily fetch them
RUN mkdir -p /usr/lib/elemental/bootloader && \
    cp /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed /usr/lib/elemental/bootloader/grubx64.efi && \
    cp /usr/lib/shim/shimx64.efi.signed /usr/lib/elemental/bootloader/shimx64.efi && \
    cp /usr/lib/shim/mmx64.efi /usr/lib/elemental/bootloader/mmx64.efi

# Good for validation after the build
CMD ["/bin/bash"]
