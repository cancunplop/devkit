#!/bin/sh
ALPINE="$(test -f /etc/alpine-release && echo 1 || echo 0)"
DEBIAN="$(test -f /etc/debian-release && echo 1 || echo 0)"

#  github-cli
[ "$DEBIAN" -eq 1 ] &&
	curl https://cli.github.com/packages/githubcli-archive-keyring.gpg |
	tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
	chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
	tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
	apt update &&
	apt install gh -y

# atuin
ATUIN_REPO="atuinsh/atuin"
ATUIN_LATEST="$(curl -s https://api.github.com/repos/$ATUIN_REPO/releases/latest | jq -r .tag_name | sed 's/^v//')"
ATUIN_TYPE="$([ "$ALPINE" -eq 1 ] && echo musl || echo gnu)"

curl -L "https://github.com/$ATUIN_REPO/releases/download/v$ATUIN_LATEST/atuin-x86_64-unknown-linux-$ATUIN_TYPE.tar.gz" |
	tar -xz --wildcards --no-anchored --strip-components 1 -C /usr/bin/ '*/atuin'

# ble.sh
BLESH_REPO="akinomyoga/ble.sh"
BLESH_LATEST="$(curl -s https://api.github.com/repos/$BLESH_REPO/releases/latest | jq -r .tag_name | sed 's/^v//')"
mkdir /usr/share/blesh &&
	curl -L "https://github.com/$BLESH_REPO/releases/download/v$BLESH_LATEST/ble-$BLESH_LATEST.tar.xz" |
	tar -xJ -C /usr/share/blesh --strip-components 1 --owner=0 --group=0 --no-same-owner --no-same-permissions

# Cheat
#BLESH_REPO="akinomyoga/ble.sh"
#BLESH_LATEST="$(curl -s https://api.github.com/repos/$BLESH_REPO/releases/latest | jq -r .tag_name | sed 's/^v//')"
#curl -L https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz |
#	gunzip - >/usr/local/bin/cheat &&
#	chmod +x /usr/local/bin/cheat

# bat extras
BATEXTRAS_REPO="eth-p/bat-extras"
BATEXTRAS_LATEST="$(curl -s https://api.github.com/repos/$BATEXTRAS_REPO/releases/latest | jq -r .tag_name | sed 's/^v//')"
curl -Lo extras.zip "https://github.com/$BATEXTRAS_REPO/releases/download/v$BATEXTRAS_LATEST/bat-extras-$BATEXTRAS_LATEST.zip" &&
	unzip extras.zip -d /tmp &&
	mv /tmp/man/* /usr/share/man/man1/ &&
	mv /tmp/bin/* /usr/bin/ &&
	rm -rf extras.zip /tmp/doc

# neovim
[ "$ALPINE" -ne 1 ] &&
	curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz |
	tar -xz --strip-components 1 -C /usr/
