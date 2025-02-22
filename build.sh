#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# Install RPMFusion
dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-41.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-41.noarch.rpm

# Install VirtualBox
find /tmp/rpms
dnf install -y /tmp/rpms/kmods/kmod-VirtualBox*.rpm
dnf install -y VirtualBox

# Install Tailscale
curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
chmod 644 /etc/yum.repos.d/tailscale.repo
dnf install -y tailscale

# Install Asus stuff
dnf5 -y copr enable lukenukem/asus-linux
dnf5 -y install asusctl asusctl-rog-gui supergfxctl
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable lukenukem/asus-linux
