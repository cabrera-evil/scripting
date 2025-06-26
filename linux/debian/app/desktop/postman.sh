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
for cmd in wget tar sudo; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
URL="https://dl.pstmn.io/download/latest/linux64"
DEST_DIR="/opt/Postman"
TMP_TAR="$(mktemp --suffix=.tar.gz)"
DESKTOP_ENTRY="/usr/share/applications/postman.desktop"
POSTMAN_BIN="/usr/bin/postman"

# ===================================
# Download
# ===================================
log "Downloading Postman..."
wget -q --show-progress -O "$TMP_TAR" "$URL"

# ===================================
# Extract
# ===================================
log "Extracting archive..."
tar -xf "$TMP_TAR" -C /tmp
rm -f "$TMP_TAR"

# ===================================
# Replace existing installation
# ===================================
if [ -e "$DEST_DIR" ]; then
	log "Removing existing Postman at $DEST_DIR..."
	sudo rm -rf "$DEST_DIR"
fi

log "Installing Postman to $DEST_DIR..."
sudo mv /tmp/Postman "$DEST_DIR"

# ===================================
# Create .desktop file
# ===================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=Postman
GenericName=API Testing Tool
Comment=Simplify API development and testing
Exec=${DEST_DIR}/Postman
Terminal=false
Type=Application
Icon=${DEST_DIR}/app/resources/app/assets/icon.png
Categories=Development;
EOF

# ===================================
# Create symlink
# ===================================
if [ -e "$POSTMAN_BIN" ]; then
	log "Removing existing Postman binary link..."
	sudo rm -f "$POSTMAN_BIN"
fi

log "Linking Postman binary to $POSTMAN_BIN..."
sudo ln -s "${DEST_DIR}/Postman" "$POSTMAN_BIN"

success "Postman has been installed or updated successfully."
