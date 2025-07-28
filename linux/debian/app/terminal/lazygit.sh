#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# DETECT ARCHITECTURE
# ===================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="x86_64" ;;
aarch64) ARCH="arm64" ;;
*) abort "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# DETECT LATEST VERSION
# ===================================
log "Fetching latest Lazygit version..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
[ -z "$VERSION" ] && abort "Unable to detect latest version."

# ===============================
# DOWNLOAD AND INSTALL
# ===================================
FILENAME="lazygit_${VERSION}_Linux_${ARCH}.tar.gz"
URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/${FILENAME}"
TMP_DIR="$(mktemp -d)"

log "Downloading Lazygit v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/lazygit.tar.gz"

log "Extracting..."
tar -xzf "${TMP_DIR}/lazygit.tar.gz" -C "$TMP_DIR" lazygit

log "Installing to /usr/local/bin..."
sudo install -m 0755 "${TMP_DIR}/lazygit" /usr/local/bin/lazygit

success "Lazygit v${VERSION} installed successfully!"
