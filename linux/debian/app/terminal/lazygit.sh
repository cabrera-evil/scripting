#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# DETECT ARCHITECTURE
# ================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="x86_64" ;;
aarch64) ARCH="arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# DETECT LATEST VERSION
# ================================
log "Fetching latest Lazygit version..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
[ -z "$VERSION" ] && die "Unable to detect latest version."

# ===============================
# DOWNLOAD AND INSTALL
# ================================
FILENAME="lazygit_${VERSION}_Linux_${ARCH}.tar.gz"
URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/${FILENAME}"
TMP_DIR="$(mktemp -d)"

log "Downloading Lazygit v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/lazygit.tar.gz"

log "Extracting..."
tar -xzf "${TMP_DIR}/lazygit.tar.gz" -C "$TMP_DIR" lazygit

log "Installing to /usr/local/bin..."
sudo install -m 0755 "${TMP_DIR}/lazygit" /usr/local/bin/lazygit

success "Lazygit v${VERSION} installed successfully!"
