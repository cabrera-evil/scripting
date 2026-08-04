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
# SCRIPT CONFIGURATION
# ================================
VERSION="0.4.20-1"
DOWNLOAD_URL="https://installers.lmstudio.ai/linux/x64/${VERSION}/LM-Studio-${VERSION}-x64.AppImage"
INSTALL_DIR="/opt/LM-Studio"
APPIMAGE_PATH="${INSTALL_DIR}/LM-Studio.AppImage"
BIN_PATH="/usr/local/bin/lm-studio"
DESKTOP_ENTRY="/usr/share/applications/lm-studio.desktop"
TMP_DIR="$(mktemp -d)"
TMP_APPIMAGE="${TMP_DIR}/LM-Studio.AppImage"
trap 'rm -rf "$TMP_DIR"' EXIT

# ================================
# CHECKS
# ================================
if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
	die "LM Studio ${VERSION} is only available for amd64 systems."
fi

# ================================
# DOWNLOAD
# ================================
log "Downloading LM Studio ${VERSION}..."
wget -O "$TMP_APPIMAGE" "$DOWNLOAD_URL"

# ================================
# INSTALL
# ================================
log "Installing LM Studio to ${INSTALL_DIR}..."
sudo install -d -m 755 "$INSTALL_DIR"
sudo install -m 755 "$TMP_APPIMAGE" "$APPIMAGE_PATH"

# ================================
# SYMLINK
# ================================
log "Creating command at ${BIN_PATH}..."
sudo ln -sfn "$APPIMAGE_PATH" "$BIN_PATH"

# ================================
# DESKTOP ENTRY
# ================================
log "Creating desktop entry..."
sudo tee "$DESKTOP_ENTRY" >/dev/null <<EOF
[Desktop Entry]
Name=LM Studio
GenericName=Local LLM Desktop Application
Comment=Discover, download, and run local large language models
Exec=${APPIMAGE_PATH} %U
Terminal=false
Type=Application
Categories=Development;Utility;
StartupWMClass=LM Studio
EOF

success "LM Studio ${VERSION} installed successfully. Run with 'lm-studio'."
