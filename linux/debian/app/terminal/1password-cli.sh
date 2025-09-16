#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	readonly RED=$'\033[0;31m'
	readonly GREEN=$'\033[0;32m'
	readonly YELLOW=$'\033[0;33m'
	readonly BLUE=$'\033[0;34m'
	readonly MAGENTA=$'\033[0;35m'
	readonly BOLD=$'\033[1m'
	readonly DIM=$'\033[2m'
	readonly NC=$'\033[0m'
else
	readonly RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
QUIET=false
DEBUG=false

# ===================================
# LOGGING FUNCTIONS
# ===================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
die() {
	error "$*"
	exit 1
}

# ===================================
# DETECT LATEST VERSION FROM PRODUCT HISTORY PAGE
# ===================================
log "Detecting latest 1Password CLI version..."
LATEST_VERSION=$(curl -s https://app-updates.agilebits.com/product_history/CLI2 |
  grep -oP '^\s*\K[0-9]+\.[0-9]+\.[0-9]+' |
  head -n1)

[ -z "$LATEST_VERSION" ] && die "Could not extract the latest version."

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
FILENAME="op_linux_${ARCH}_v${LATEST_VERSION}.zip"
URL="https://cache.agilebits.com/dist/1P/op2/pkg/v${LATEST_VERSION}/${FILENAME}"
TMP_ZIP="$(mktemp --suffix=.zip)"
TMP_DIR="$(mktemp -d)"
INSTALL_PATH="/usr/local/bin/op"
GROUP="onepassword-cli"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading 1Password CLI v${LATEST_VERSION} for ${ARCH}..."
wget -O "$TMP_ZIP" "$URL"

# ===================================
# EXTRACT
# ===================================
log "Extracting archive..."
unzip -q "$TMP_ZIP" -d "$TMP_DIR"

# ===================================
# INSTALL
# ===================================
log "Installing to ${INSTALL_PATH}..."
sudo mv "${TMP_DIR}/op" "$INSTALL_PATH"

# ===================================
# PERMISSIONS
# ===================================
log "Setting permissions..."
sudo groupadd -f "$GROUP"
sudo chgrp "$GROUP" "$INSTALL_PATH"
sudo chmod g+s "$INSTALL_PATH"

success "1Password CLI v${LATEST_VERSION} installed successfully!"
