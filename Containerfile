# Query kernel version for building kmod
FROM ghcr.io/ublue-os/kinoite-main:42 as kernel-query

RUN rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}' > /kernel-version.txt && \
    echo "Detected kernel version: $(cat /kernel-version.txt)"

# Build VirtualBox kmod
FROM quay.io/fedora/fedora:42 AS builder

COPY build-kmod-VirtualBox.sh /tmp/build-kmod-VirtualBox.sh
COPY certs /tmp/certs
COPY --from=kernel-query /kernel-version.txt /kernel-version.txt

RUN /tmp/build-kmod-VirtualBox.sh

# Build system image
FROM ghcr.io/ublue-os/kinoite-main:42

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

COPY --from=builder /var/cache/akmods/VirtualBox /tmp/VirtualBox
COPY --from=ghcr.io/ublue-os/akmods-nvidia:main-42 / /tmp/akmods-nvidia

COPY build.sh /tmp/build.sh
COPY nvidia-install.sh /tmp/nvidia-install.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
