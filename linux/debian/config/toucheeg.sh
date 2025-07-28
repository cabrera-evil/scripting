#!/usr/bin/env bash
set -euo pipefail

# ================================
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

# ================================
# CHECKS
# ===================================
for cmd in curl grep wget dpkg sudo; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# DETECT LATEST VERSION
# ===================================
log "Detecting latest touchegg version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/JoseExposito/touchegg/releases/latest |
    grep -Po '"tag_name":\s*"\K[0-9.]+' || true)

[ -z "$LATEST_VERSION" ] && abort "Could not determine the latest version."

# ================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
FILENAME="touchegg_${LATEST_VERSION}_${ARCH}.deb"
URL="https://github.com/JoseExposito/touchegg/releases/download/${LATEST_VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ================================
# DOWNLOAD
# ===================================
log "Downloading touchegg ${LATEST_VERSION}..."
wget -O "$TMP_DEB" "$URL"

# ================================
# INSTALL
# ===================================
log "Installing touchegg..."
sudo apt install -y "$TMP_DEB"

# ================================
# DONE
# ===================================
success "touchegg ${LATEST_VERSION} installed successfully!"
