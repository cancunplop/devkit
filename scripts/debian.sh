#!/bin/sh

# Symlink distrobox shims
./distrobox-shims.sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND
# Update the container and install packages
apt-get update && apt-get upgrade -y
grep -v '^#' ./debian.packages | xargs apt-get install -y

# Python packages
if [ -s /python.packages ]; then
	grep -v '^#' ./python.packages-pip |
		xargs pip install --break-system-packages
fi

# Install homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bashrc
grep -v '^#' ./brew.packages |
	xargs brew install &&
	brew cleanup &&
	rm -rf "$(brew --cache)"

# Packages without debian packages
#./extra-packages.sh

rm -rf /var/lib/apt/lists/*
