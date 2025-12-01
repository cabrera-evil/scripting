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
ARCH="$(uname -m)"
# GitHub release assets use "arm64" instead of "aarch64"; normalize here.
case "$ARCH" in
	aarch64) TARGET_ARCH="arm64" ;;
	*) TARGET_ARCH="$ARCH" ;;
esac
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${TARGET_ARCH}.tar.gz"
TMP_TAR="$(mktemp --suffix=.tar.gz)"
INSTALL_DIR="/opt/nvim"
BIN_LINK="/usr/local/bin/nvim"

# ================================
# DOWNLOAD
# ================================
log "Downloading latest Neovim binary for ${ARCH}..."
wget -O "$TMP_TAR" "$URL"

# ================================
# INSTALL
# ================================
log "Extracting Neovim into ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf "$TMP_TAR" -C "$INSTALL_DIR" --strip-components=1

# ================================
# SYMLINK
# ================================
log "Creating symlink to ${BIN_LINK}..."
sudo ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_LINK"

success "Neovim installed successfully at ${BIN_LINK}"
