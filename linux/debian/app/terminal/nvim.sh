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
for cmd in curl wget tar sudo ln; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(uname -m)"
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
TMP_TAR="$(mktemp --suffix=.tar.gz)"
INSTALL_DIR="/opt/nvim"
BIN_LINK="/usr/local/bin/nvim"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading latest Neovim binary for ${ARCH}..."
wget -O "$TMP_TAR" "$URL"

# ===================================
# INSTALL
# ===================================
log "Extracting Neovim into ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf "$TMP_TAR" -C "$INSTALL_DIR" --strip-components=1

# ===================================
# SYMLINK
# ===================================
log "Creating symlink to ${BIN_LINK}..."
sudo ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_LINK"

success "Neovim installed successfully at ${BIN_LINK}"
