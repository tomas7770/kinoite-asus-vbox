#!/bin/bash

set -ouex pipefail

dnf install -y \
    akmods \
    mock \
    kernel

KERNEL="$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-41.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-41.noarch.rpm

dnf install -y \
    akmod-VirtualBox
akmods --force --kernels "${KERNEL}" --kmod VirtualBox
