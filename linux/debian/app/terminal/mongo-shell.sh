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
# DETECT LATEST VERSION
# ================================
log "Detecting latest MongoDB Shell version..."
ARCH="$(uname -m)"
[[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

PACKAGE=$(curl -s https://www.mongodb.com/try/download/shell |
	grep -oP "mongodb-mongosh_[0-9]+\.[0-9]+\.[0-9]+_${ARCH}\.deb" |
	head -n1)

[ -z "$PACKAGE" ] && die "Could not detect latest version for architecture: ${ARCH}"

LATEST_VERSION=$(echo "$PACKAGE" | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')

# ================================
# CONFIG
# ================================
URL="https://downloads.mongodb.com/compass/${PACKAGE}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ================================
# DOWNLOAD
# ================================
log "Downloading MongoDB Shell v${LATEST_VERSION}..."
wget -O "$TMP_DEB" "$URL"

# ================================
# INSTALL
# ================================
log "Installing package..."
sudo apt install -y "$TMP_DEB"
success "MongoDB Shell v${LATEST_VERSION} installed successfully!"
