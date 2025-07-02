#!/bin/bash

set -ouex pipefail

KERNEL="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

### Install packages

# Packages can be installed from any enabled yum repo on the image.

# Install Asus stuff
dnf5 -y copr enable lukenukem/asus-linux
dnf5 -y install asusctl asusctl-rog-gui supergfxctl
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable lukenukem/asus-linux

# Install RPMFusion (needed by VirtualBox)
dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-42.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-42.noarch.rpm

# Install VirtualBox
find /tmp/VirtualBox
dnf install -y /tmp/VirtualBox/*${KERNEL}*.rpm # kmod
dnf install -y VirtualBox

# Install Tailscale
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
chmod 644 /etc/yum.repos.d/tailscale.repo
dnf install -y tailscale

# Install Sunshine
dnf5 -y copr enable lizardbyte/beta
dnf5 -y install Sunshine
dnf5 -y copr disable lizardbyte/beta

# Install libvirt/virt-manager
dnf5 -y install libvirt virt-manager

# Install nvidia drivers
AKMODNV_PATH=/tmp/akmods-nvidia/rpms /tmp/nvidia-install.sh
