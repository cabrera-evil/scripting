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
for cmd in wget curl grep sed awk sudo dpkg apt lsb_release; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect latest version
# ===================================
log "Fetching latest VirtualBox version..."
LATEST_VERSION=$(curl -s https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT) || abort "Could not retrieve latest version"
ARCH="$(dpkg --print-architecture)"
CODENAME="$(lsb_release -sc)"

# Extract build number dynamically from directory listing
log "Fetching build number for v$LATEST_VERSION..."
BUILD=$(curl -s "https://download.virtualbox.org/virtualbox/${LATEST_VERSION}/" |
    grep -oP "virtualbox-[0-9.]+-\K[0-9]+(?=~Debian~${CODENAME}_${ARCH}\.deb)" |
    head -n1)

[ -z "$BUILD" ] && abort "Could not determine build number for $LATEST_VERSION and $CODENAME/$ARCH"

# ===================================
# Config
# ===================================
FILENAME="virtualbox-7.1_${LATEST_VERSION}-${BUILD}~Debian~${CODENAME}_${ARCH}.deb"
URL="https://download.virtualbox.org/virtualbox/${LATEST_VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# Download
# ===================================
log "Downloading VirtualBox $LATEST_VERSION (build $BUILD) for $ARCH on $CODENAME..."
wget -q --show-progress -O "$TMP_DEB" "$URL"

# ===================================
# Install
# ===================================
log "Installing VirtualBox..."
sudo apt install -y "$TMP_DEB"

# ===================================
# Cleanup
# ===================================
rm -f "$TMP_DEB"
success "VirtualBox $LATEST_VERSION installed successfully!"
