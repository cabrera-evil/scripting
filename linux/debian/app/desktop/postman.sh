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
INSTALL_DIR="/opt/Postman"
TMP_DIR="$(mktemp -d)"
TMP_TAR="${TMP_DIR}/toolbox.tar.gz"
DESKTOP_ENTRY="/usr/share/applications/postman.desktop"
POSTMAN_BIN="/usr/bin/postman"

# ===================================
# Download
# ===================================
log "Downloading Postman..."
wget -O "$TMP_TAR" "$URL"

# ===================================
# Extract
# ===================================
log "Extracting archive..."
tar -xzf "$TMP_TAR" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'Postman*' | head -n1)"

# ===================================
# Replace existing installation
# ===================================
if [ -e "$INSTALL_DIR" ]; then
	log "Removing existing Postman at $INSTALL_DIR..."
	sudo rm -rf "$INSTALL_DIR"
fi

log "Installing Postman to $INSTALL_DIR..."
sudo mv $EXTRACTED_DIR "$INSTALL_DIR"

# ===================================
# Create .desktop file
# ===================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=Postman
GenericName=API Testing Tool
Comment=Simplify API development and testing
Exec=${INSTALL_DIR}/Postman
Terminal=false
Type=Application
Icon=${INSTALL_DIR}/app/resources/app/assets/icon.png
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
sudo ln -s "${INSTALL_DIR}/Postman" "$POSTMAN_BIN"

success "Postman has been installed or updated successfully."
