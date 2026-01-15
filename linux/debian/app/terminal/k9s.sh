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
fi

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
# SCRIPT CONFIG
# ================================
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
amd64 | arm64) ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

FILENAME="k9s_linux_${ARCH}.deb"
URL="https://github.com/derailed/k9s/releases/latest/download/${FILENAME}"
TMP_DIR="$(mktemp -d)"
TMP_DEB="${TMP_DIR}/${FILENAME}"

cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# ================================
# DOWNLOAD
# ================================
log "Downloading k9s package (${ARCH})..."
wget -O "$TMP_DEB" "$URL"

# ================================
# INSTALL
# ================================
log "Installing k9s..."
sudo apt install -y "$TMP_DEB"

success "k9s installed successfully!"
