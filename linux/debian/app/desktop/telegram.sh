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
# RESOLVE LATEST VERSION URL
# ================================
BASE_URL="https://telegram.org/dl/desktop/linux"
FINAL_URL=$(curl -Ls -o /dev/null -w %{url_effective} "$BASE_URL") || die "Failed to resolve latest Telegram URL"
VERSION="$(basename "$FINAL_URL" | sed -nE 's/tsetup\.([0-9.]+)\.tar\.xz/\1/p')"
if [[ -z "$VERSION" ]]; then
	VERSION="latest"
fi

# ================================
# CONFIG
# ================================
INSTALL_DIR="/opt/Telegram"
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/telegram.tar.xz"
DESKTOP_ENTRY="/usr/share/applications/telegram.desktop"
TELEGRAM_BIN="/usr/bin/telegram"
ICON_URL="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/telegram.png"
ICON_PATH="${INSTALL_DIR}/telegram.png"

# ================================
# DOWNLOAD
# ================================
log "Downloading Telegram Desktop version $VERSION..."
wget -O "$TMP_FILE" "$FINAL_URL"

# ================================
# EXTRACT
# ================================
log "Extracting archive..."
tar -xf "$TMP_FILE" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -type d -name 'Telegram' | head -n1)"

# ================================
# REPLACE EXISTING INSTALLATION
# ================================
if [ -e "$INSTALL_DIR" ]; then
	log "Removing existing Telegram at $INSTALL_DIR..."
	sudo rm -rf "$INSTALL_DIR"
fi

log "Installing Telegram to $INSTALL_DIR..."
sudo mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# ================================
# INSTALL ICON
# ================================
log "Installing Telegram icon..."
sudo wget -O "$ICON_PATH" "$ICON_URL"

# ================================
# CREATE .DESKTOP FILE
# ================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=Telegram
GenericName=Telegram Desktop
Comment=Fast and secure messaging
Exec=${INSTALL_DIR}/Telegram
Terminal=false
Type=Application
Icon=${ICON_PATH}
Categories=Network;InstantMessaging;
EOF

# ================================
# CREATE SYMLINK
# ================================
if [ -e "$TELEGRAM_BIN" ]; then
	log "Removing existing Telegram binary link..."
	sudo rm -f "$TELEGRAM_BIN"
fi

log "Linking Telegram binary to $TELEGRAM_BIN..."
sudo ln -s "${INSTALL_DIR}/Telegram" "$TELEGRAM_BIN"

success "Telegram Desktop $VERSION has been installed or updated successfully."
