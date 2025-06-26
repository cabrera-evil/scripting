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
for cmd in wget sudo dpkg apt; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
URL="https://discord.com/api/download?platform=linux"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# Download
# ===================================
log "Downloading latest Discord release..."
wget -q --show-progress -O "$TMP_DEB" "$URL"

# ===================================
# Install
# ===================================
log "Installing Discord..."
sudo apt install -y "$TMP_DEB"

success "Discord installed successfully!"
