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
log()     { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort()   { echo -e "${RED}✗ $1${NC}" >&2; exit 1; }

# ===================================
# Checks
# ===================================
for cmd in curl grep wget unzip sudo dpkg sed awk; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect latest version from product history page
# ===================================
log "Detecting latest 1Password CLI version..."
LATEST_VERSION=$(curl -s https://app-updates.agilebits.com/product_history/CLI2 \
  | grep -oP '^\s*\K[0-9]+\.[0-9]+\.[0-9]+' \
  | head -n1)

[ -z "$LATEST_VERSION" ] && abort "Could not extract the latest version."

# ===================================
# Config
# ===================================
ARCH="$(dpkg --print-architecture)"
FILENAME="op_linux_${ARCH}_v${LATEST_VERSION}.zip"
URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${LATEST_VERSION}/${FILENAME}"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"
INSTALL_PATH="/usr/local/bin/op"
GROUP="onepassword-cli"

# ===================================
# Download
# ===================================
log "Downloading 1Password CLI v${LATEST_VERSION} for ${ARCH}..."
wget -q --show-progress -O "$TMP_ZIP" "$URL"

# ===================================
# Extract
# ===================================
log "Extracting archive..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# Install
# ===================================
log "Installing to ${INSTALL_PATH}..."
sudo mv "${TMP_DIR}/op" "$INSTALL_PATH"

# ===================================
# Permissions
# ===================================
log "Setting permissions..."
sudo groupadd -f "$GROUP"
sudo chgrp "$GROUP" "$INSTALL_PATH"
sudo chmod g+s "$INSTALL_PATH"

# ===================================
# Cleanup
# ===================================
rm -rf "$TMP_ZIP" "$TMP_DIR"
success "1Password CLI v${LATEST_VERSION} installed successfully!"
