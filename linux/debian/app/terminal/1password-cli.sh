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
    if [ "$SILENT" != true ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != true ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != true ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != true ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in curl grep wget unzip sudo dpkg sed awk; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION FROM PRODUCT HISTORY PAGE
# ===================================
log "Detecting latest 1Password CLI version..."
LATEST_VERSION=$(curl -s https://app-updates.agilebits.com/product_history/CLI2 |
  grep -oP '^\s*\K[0-9]+\.[0-9]+\.[0-9]+' |
  head -n1)

[ -z "$LATEST_VERSION" ] && abort "Could not extract the latest version."

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
FILENAME="op_linux_${ARCH}_v${LATEST_VERSION}.zip"
URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${LATEST_VERSION}/${FILENAME}"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"
INSTALL_PATH="/usr/local/bin/op"
GROUP="onepassword-cli"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading 1Password CLI v${LATEST_VERSION} for ${ARCH}..."
wget -O "$TMP_ZIP" "$URL"

# ===================================
# EXTRACT
# ===================================
log "Extracting archive..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# INSTALL
# ===================================
log "Installing to ${INSTALL_PATH}..."
sudo mv "${TMP_DIR}/op" "$INSTALL_PATH"

# ===================================
# PERMISSIONS
# ===================================
log "Setting permissions..."
sudo groupadd -f "$GROUP"
sudo chgrp "$GROUP" "$INSTALL_PATH"
sudo chmod g+s "$INSTALL_PATH"

success "1Password CLI v${LATEST_VERSION} installed successfully!"
