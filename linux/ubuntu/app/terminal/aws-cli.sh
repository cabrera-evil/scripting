#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

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
for cmd in curl wget unzip sudo; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
ARCH="$(uname -m)"
URL="https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"

# ===================================
# Download
# ===================================
log "Downloading AWS CLI v2 for ${ARCH}..."
wget -q --show-progress -O "$TMP_ZIP" "$URL"

# ===================================
# Extract
# ===================================
log "Unpacking installer..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# Install
# ===================================
log "Installing AWS CLI..."
sudo "${TMP_DIR}/aws/install" --update

success "AWS CLI v2 installed successfully!"
