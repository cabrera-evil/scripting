#!/usr/bin/env bash
set -euo pipefail

# ===============================
# COLORS
# ===================================
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

# ===============================
# DETECT ARCHITECTURE
# ===================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="linux" ;;
aarch64) ARCH="linux-arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# DETECT LATEST VERSION
# ===================================
log "Fetching latest Snyk version..."
VERSION=$(curl -s https://api.github.com/repos/snyk/cli/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')
[ -z "$VERSION" ] && die "Unable to detect latest version."

# ===============================
# DOWNLOAD AND INSTALL
# ===================================
FILENAME="snyk-${ARCH}"
URL="https://github.com/snyk/cli/releases/download/v${VERSION}/${FILENAME}"
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/snyk"

log "Downloading Snyk v${VERSION}..."
wget -O "$TMP_FILE" "$URL" || die "Failed to download Snyk."

log "Installing to /usr/local/bin..."
sudo apt install "${TMP_DIR}/snyk"

success "Snyk v${VERSION} installed successfully!"
