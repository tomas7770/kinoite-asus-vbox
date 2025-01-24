#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# Install RPMFusion
rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-41.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-41.noarch.rpm
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

find /tmp/rpms
rpm-ostree install /tmp/rpms/kmods/kmod-VirtualBox*.rpm
rpm-ostree install VirtualBox

curl https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
chmod 644 /etc/yum.repos.d/tailscale.repo
rpm-ostree install tailscale
