#!/bin/sh
# Atuin
curl -L https://github.com/atuinsh/atuin/releases/download/v18.4.0/atuin-x86_64-unknown-linux-musl.tar.gz |
	tar -xz --wildcards --no-anchored --strip-components 1 -C /usr/bin/ '*/atuin'

# ble.sh
mkdir /usr/share/blesh &&
	curl -L https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz |
	tar -xJ -C /usr/share/blesh --strip-components 1 --owner=0 --group=0 --no-same-owner --no-same-permissions

# Cheat
curl -L https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz |
	gunzip - >/usr/local/bin/cheat &&
	chmod +x /usr/local/bin/cheat

# bat extras
curl -Lo extras.zip https://github.com/eth-p/bat-extras/releases/download/v2024.08.24/bat-extras-2024.08.24.zip &&
	unzip extras.zip -d /tmp &&
	mv /tmp/man/* /usr/share/man/man1/ &&
	mv /tmp/bin/* /usr/bin/ &&
	rm -rf extras.zip /tmp/doc
