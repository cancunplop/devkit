#!/bin/bash

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
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" | tee -a ~/.bashrc /etc/profile.d/99-brew.sh
sed -i 's#\(secure_path=\)"\(.*\)"#\1="\2,/home/linuxbrew/.linuxbrew/bin,/home/linuxbrew/.linuxbrew/sbin#g' /etc/sudoers
brew bundle --file=<(awk '!/^#/{printf "brew \"%s\"\n",$1}' ./brew.packages) &&
	brew cleanup &&
	rm -rf "$(brew --cache)"

# Packages without debian packages
#./extra-packages.sh

# locale
export LANG=en_GB.UTF-8
apt-get install -y locales &&
	sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen &&
	dpkg-reconfigure --frontend=noninteractive locales &&
	update-locale LANG="$LANG"

# motd
cat <<EOF | tee -a /etc/motd.boxkit
If you need to install 'brew' packages, you need to make sure that your user can modify brew directories :
chown -R \$(id -u) \$(brew --prefix)
To use your chezmoi : chezmoi init <REMOTE REPO CHEZMOI> --apply --purge
To install your lazygit configuration : git clone <REMOTE REMOTE LAZYGIT> ~/.config/nvim
The starter can be found here : https://github.com/LazyVim/starter
EOF

cat <<EOF | tee -a /etc/profile.d/motd.sh
#!/bin/bash
printf "\n"
cat /etc/motd.boxkit
EOF

rm -rf /var/lib/apt/lists/*
