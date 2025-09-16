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
# CHECKS
# ===================================
for cmd in curl wget tar sudo ln; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(uname -m)"
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
TMP_TAR="$(mktemp --suffix=.tar.gz)"
INSTALL_DIR="/opt/nvim"
BIN_LINK="/usr/local/bin/nvim"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading latest Neovim binary for ${ARCH}..."
wget -O "$TMP_TAR" "$URL"

# ===================================
# INSTALL
# ===================================
log "Extracting Neovim into ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf "$TMP_TAR" -C "$INSTALL_DIR" --strip-components=1

# ===================================
# SYMLINK
# ===================================
log "Creating symlink to ${BIN_LINK}..."
sudo ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_LINK"

success "Neovim installed successfully at ${BIN_LINK}"
