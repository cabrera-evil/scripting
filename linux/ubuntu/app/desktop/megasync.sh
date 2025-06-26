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
for cmd in wget sudo dpkg apt lsb_release; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
DISTRO_CODENAME="$(lsb_release -cs)" # e.g., bookworm, bullseye, etc.
ARCH="$(dpkg --print-architecture)"  # e.g., amd64, arm64
URL="https://mega.nz/linux/repo/Debian_12/${ARCH}/megasync-Debian_12_${ARCH}.deb"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# Download
# ===================================
log "Downloading MegaSync for Debian 12 (${ARCH})..."
wget -q --show-progress -O "$TMP_DEB" "$URL"

# ===================================
# Install
# ===================================
log "Installing MegaSync..."
sudo apt install -y "$TMP_DEB"

success "MegaSync installed successfully!"
