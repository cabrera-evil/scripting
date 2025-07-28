#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in wget sudo dpkg apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================

# Expected arch x64, etc
ARCH="$(dpkg --print-architecture | sed 's/^amd64$/x64/; s/^armhf$/arm/')"
TMP_DEB="$(mktemp --suffix=.deb)"
URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-${ARCH}"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading Visual Studio Code (stable, ${ARCH})..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing Visual Studio Code..."
sudo apt install -y "$TMP_DEB"

success "Visual Studio Code installed successfully!"
