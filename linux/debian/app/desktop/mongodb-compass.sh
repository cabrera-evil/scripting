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
for cmd in wget sudo dpkg apt sed; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
VERSION="1.46.3"
URL="https://downloads.mongodb.com/compass/mongodb-compass_${VERSION}_${ARCH}.deb"
TMP_DEB="$(mktemp --suffix=.deb)"
DESKTOP_FILE="/usr/share/applications/mongodb-compass.desktop"
EXTRA_FLAGS='--password-store="gnome-libsecret" --ignore-additional-command-line-flags'

# ===================================
# DOWNLOAD
# ===================================
log "Downloading MongoDB Compass v$VERSION for $ARCH..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing MongoDB Compass..."
sudo apt install -y "$TMP_DEB"

# ===================================
# PATCH .DESKTOP LAUNCHER
# ===================================
log "Patching .desktop launcher with secure credential flags..."
if [[ -f "$DESKTOP_FILE" ]]; then
	sudo sed -i -E "s|^(Exec=.*mongodb-compass)(.*)|\1 ${EXTRA_FLAGS}|" "$DESKTOP_FILE"
	success "Desktop entry updated with flags:"
	echo -e "${YELLOW}  $EXTRA_FLAGS${NC}"
else
	warn "Desktop file not found: $DESKTOP_FILE"
fi

success "MongoDB Compass installed successfully!"
