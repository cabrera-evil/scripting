#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	RED=$'\033[0;31m'
	GREEN=$'\033[0;32m'
	YELLOW=$'\033[0;33m'
	BLUE=$'\033[0;34m'
	MAGENTA=$'\033[0;35m'
	BOLD=$'\033[1m'
	DIM=$'\033[2m'
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false

# ================================
# LOGGING FUNCTIONS
# ================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
die() {
	error "$*"
	exit 1
}

# ================================
# CONFIG
# ================================
URL="https://dl.pstmn.io/download/latest/linux64"
INSTALL_DIR="/opt/Postman"
TMP_DIR="$(mktemp -d)"
TMP_TAR="${TMP_DIR}/toolbox.tar.gz"
DESKTOP_ENTRY="/usr/share/applications/postman.desktop"
POSTMAN_BIN="/usr/bin/postman"

# ================================
# DOWNLOAD
# ================================
log "Downloading Postman..."
wget -O "$TMP_TAR" "$URL"

# ================================
# EXTRACT
# ================================
log "Extracting archive..."
tar -xzf "$TMP_TAR" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'Postman*' | head -n1)"

# ================================
# REPLACE EXISTING INSTALLATION
# ================================
if [ -e "$INSTALL_DIR" ]; then
	log "Removing existing Postman at $INSTALL_DIR..."
	sudo rm -rf "$INSTALL_DIR"
fi

log "Installing Postman to $INSTALL_DIR..."
sudo mv $EXTRACTED_DIR "$INSTALL_DIR"

# ================================
# CREATE .DESKTOP FILE
# ================================
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

# ================================
# CREATE SYMLINK
# ================================
if [ -e "$POSTMAN_BIN" ]; then
	log "Removing existing Postman binary link..."
	sudo rm -f "$POSTMAN_BIN"
fi

log "Linking Postman binary to $POSTMAN_BIN..."
sudo ln -s "${INSTALL_DIR}/Postman" "$POSTMAN_BIN"

success "Postman has been installed or updated successfully."
