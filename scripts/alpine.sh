#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh
./extra-packages.sh

# Update the container and install packages
apk update && apk upgrade
grep -v '^#' ./alpine.packages | xargs apk add
# Testing packages
if [ -s ./alpine-testing.packages ]; then
	grep -v '^#' ./alpine-testing.packages |
		xargs apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
fi
# Python packages
if [ -s /python.packages ]; then
	grep -v '^#' ./python.packages-pip |
		xargs pip install --break-system-packages
fi
