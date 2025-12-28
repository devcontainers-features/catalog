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
    ARCH_SUFFIX="x64"
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
  DOWNLOAD_URL="https://github.com/sst/opencode/releases/latest/download/opencode-linux-${ARCH_SUFFIX}.tar.gz"
else
  DOWNLOAD_URL="https://github.com/sst/opencode/releases/download/${VERSION}/opencode-linux-${ARCH_SUFFIX}.tar.gz"
fi

# Download and install opencode
echo "Downloading opencode from ${DOWNLOAD_URL}..."
curl -fsSL "${DOWNLOAD_URL}" -o /tmp/opencode.tar.gz
tar -C /tmp -xzf /tmp/opencode.tar.gz
mv /tmp/opencode /usr/local/bin/opencode
rm /tmp/opencode.tar.gz

OPENCODE_CONFIG_PATH="$_REMOTE_USER_HOME/.config/opencode"

# Create the global config
mkdir -p "$OPENCODE_CONFIG_PATH"
# Copy the configuration
cp -R files/* "$OPENCODE_CONFIG_PATH"
