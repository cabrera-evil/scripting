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
log "Detecting latest RealVNC Connect .deb version..."
PAGE_URL="https://www.realvnc.com/en/connect/download/vnc/"
ARCH="x64"

DEB_URL=$(curl -s "$PAGE_URL" |
	grep -oP "https://.*?RealVNC-Connect-[\d\.]+-Linux-${ARCH}\.deb\?[^\"']+" |
	head -n1)

[ -z "$DEB_URL" ] && die "Could not find latest RealVNC .deb URL."

FILENAME="$(basename "${DEB_URL%%\?*}")"
VERSION="$(echo "$FILENAME" | grep -oP '[\d]+\.[\d]+\.[\d]+')"
TMP_DEB="$(mktemp --suffix=.deb)"

# ================================
# DOWNLOAD
# ================================
log "Downloading RealVNC Connect v$VERSION..."
wget -O "$TMP_DEB" "$DEB_URL"

# ================================
# INSTALL
# ================================
log "Installing RealVNC Connect..."
sudo apt install -y "$TMP_DEB"

success "RealVNC Connect v$VERSION installed successfully!"
