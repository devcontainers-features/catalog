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

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    ARCH_SUFFIX="x86_64"
    ;;
  aarch64|arm64)
    ARCH_SUFFIX="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Build download URL based on version and architecture
if [ "$VERSION" = "latest" ]; then
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH_SUFFIX}.tar.gz"
else
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-${ARCH_SUFFIX}.tar.gz"
fi

# Download and install Neovim
echo "Downloading Neovim from ${DOWNLOAD_URL}..."
curl -fsSL "${DOWNLOAD_URL}" -o /tmp/nvim-linux.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf /tmp/nvim-linux.tar.gz
mv /opt/nvim-linux-${ARCH_SUFFIX} /opt/nvim
rm /tmp/nvim-linux.tar.gz

# Make nvim available for everybody
ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
