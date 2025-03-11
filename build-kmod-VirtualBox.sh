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

if [[ ! -s "/tmp/certs/private_key.priv" ]]; then
    echo "WARNING: Using test signing key."
    install -Dm644 /tmp/certs/public_key.der.test   /etc/pki/akmods/certs/public_key.der
    install -Dm644 /tmp/certs/private_key.priv.test /etc/pki/akmods/private/private_key.priv
else
    install -Dm644 /tmp/certs/public_key.der   /etc/pki/akmods/certs/public_key.der
    install -Dm644 /tmp/certs/private_key.priv /etc/pki/akmods/private/private_key.priv
fi

dnf install -y \
    akmod-VirtualBox
akmods --force --kernels "${KERNEL}" --kmod VirtualBox
