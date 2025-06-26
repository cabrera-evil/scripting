#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# Logging
# ===================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
for cmd in curl grep wget dpkg sudo sed awk; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect latest version
# ===================================
log "Detecting latest MongoDB Database Tools version..."
LATEST_VERSION=$(curl -s https://www.mongodb.com/try/download/database-tools |
    grep -oP 'mongodb-database-tools-debian12-[^"]+\.deb' |
    grep "$(uname -m)" |
    head -n1 |
    sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)\.deb/\1/')

[ -z "$LATEST_VERSION" ] && abort "Could not detect latest version."

# ===================================
# Config
# ===================================
ARCH="$(uname -m)"
PACKAGE="mongodb-database-tools-debian12-${ARCH}-${LATEST_VERSION}.deb"
URL="https://fastdl.mongodb.org/tools/db/${PACKAGE}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# Download
# ===================================
log "Downloading MongoDB Database Tools v${LATEST_VERSION}..."
wget -q --show-progress -O "$TMP_DEB" "$URL"

# ===================================
# Install
# ===================================
log "Installing package..."
sudo apt install -y "$TMP_DEB"

# ===================================
# Cleanup
# ===================================
rm -f "$TMP_DEB"
success "MongoDB Database Tools v${LATEST_VERSION} installed successfully!"
