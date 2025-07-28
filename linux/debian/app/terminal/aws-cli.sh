#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

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
for cmd in curl wget unzip sudo; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(uname -m)"
URL="https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading AWS CLI v2 for ${ARCH}..."
wget -O "$TMP_ZIP" "$URL"

# ===================================
# EXTRACT
# ===================================
log "Unpacking installer..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# INSTALL
# ===================================
log "Installing AWS CLI..."
sudo "${TMP_DIR}/aws/install" --update

success "AWS CLI v2 installed successfully!"
