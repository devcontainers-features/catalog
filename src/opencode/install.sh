#!/bin/sh
set -e

apt_get_update() {
  if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
    echo "Running apt-get update..."
    apt-get update -y
  fi
}

# Checks if packages are installed and installs them if not
apt_get() {
  if ! dpkg -s "$@" >/dev/null 2>&1; then
    apt-get -y install --no-install-recommends "$@"
  fi
}

apt_get_update
apt_get ca-certificates
apt_get curl

[ "$VERSION" = "latest" ] && unset VERSION

# Install opencode
curl -fsSL https://opencode.ai/install | bash

# Make opencode available for everybody
mv "$HOME/.opencode/bin/opencode" /usr/local/bin/opencode
