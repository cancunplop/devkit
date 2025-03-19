#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh
./extra-packages.sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND
# Update the container and install packages
apt-get update && apt-get upgrade
grep -v '^#' ./debian.packages | xargs apt-get install -y

# Python packages
if [ -s /python.packages ]; then
	grep -v '^#' ./python.packages-pip |
		xargs pip install --break-system-packages
fi
