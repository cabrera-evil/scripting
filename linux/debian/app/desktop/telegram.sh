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
for cmd in wget tar curl sudo; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# RESOLVE LATEST VERSION URL
# ===================================
BASE_URL="https://td.telegram.org/tlinux/tsetup.tar.xz"
FINAL_URL=$(curl -Ls -o /dev/null -w %{url_effective} "$BASE_URL") || abort "Failed to resolve latest Telegram URL"
VERSION=$(basename "$FINAL_URL" | sed -E 's/tsetup\.([0-9.]+)\.tar\.xz/\1/') || abort "Failed to parse version from URL"

# ===================================
# CONFIG
# ===================================
INSTALL_DIR="/opt/Telegram"
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/telegram.tar.xz"
DESKTOP_ENTRY="/usr/share/applications/telegram.desktop"
TELEGRAM_BIN="/usr/bin/telegram"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading Telegram Desktop version $VERSION..."
wget -O "$TMP_FILE" "$FINAL_URL"

# ===================================
# EXTRACT
# ===================================
log "Extracting archive..."
tar -xf "$TMP_FILE" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'Telegram' | head -n1)"

# ===================================
# REPLACE EXISTING INSTALLATION
# ===================================
if [ -e "$INSTALL_DIR" ]; then
	log "Removing existing Telegram at $INSTALL_DIR..."
	sudo rm -rf "$INSTALL_DIR"
fi

log "Installing Telegram to $INSTALL_DIR..."
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# ===================================
# CREATE .DESKTOP FILE
# ===================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=Telegram
GenericName=Telegram Desktop
Comment=Fast and secure messaging
Exec=${INSTALL_DIR}/Telegram
Terminal=false
Type=Application
Icon=${INSTALL_DIR}/telegram.png
Categories=Network;InstantMessaging;
EOF

# ===================================
# CREATE SYMLINK
# ===================================
if [ -e "$TELEGRAM_BIN" ]; then
	log "Removing existing Telegram binary link..."
	sudo rm -f "$TELEGRAM_BIN"
fi

log "Linking Telegram binary to $TELEGRAM_BIN..."
sudo ln -s "${INSTALL_DIR}/Telegram" "$TELEGRAM_BIN"

success "Telegram Desktop $VERSION has been installed or updated successfully."
