#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
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
for cmd in wget curl grep sed sudo dpkg apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION
# ===================================
log "Detecting latest RealVNC Connect .deb version..."
PAGE_URL="https://www.realvnc.com/en/connect/download/vnc/"
ARCH="x64"

DEB_URL=$(curl -s "$PAGE_URL" |
	grep -oP "https://.*?RealVNC-Connect-[\d\.]+-Linux-${ARCH}\.deb\?[^\"']+" |
	head -n1)

[ -z "$DEB_URL" ] && abort "Could not find latest RealVNC .deb URL."

FILENAME="$(basename "${DEB_URL%%\?*}")"
VERSION="$(echo "$FILENAME" | grep -oP '[\d]+\.[\d]+\.[\d]+')"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading RealVNC Connect v$VERSION..."
wget -O "$TMP_DEB" "$DEB_URL"

# ===================================
# INSTALL
# ===================================
log "Installing RealVNC Connect..."
sudo apt install -y "$TMP_DEB"

success "RealVNC Connect v$VERSION installed successfully!"
