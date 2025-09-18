#!/usr/bin/env bash
set -euo pipefail

# ================================
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

# ================================
# DETECT LATEST VERSION
# ===================================
log "Detecting latest touchegg version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/JoseExposito/touchegg/releases/latest |
    grep -Po '"tag_name":\s*"\K[0-9.]+' || true)

[ -z "$LATEST_VERSION" ] && die "Could not determine the latest version."

# ================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
FILENAME="touchegg_${LATEST_VERSION}_${ARCH}.deb"
URL="https://github.com/JoseExposito/touchegg/releases/download/${LATEST_VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ================================
# DOWNLOAD
# ===================================
log "Downloading touchegg ${LATEST_VERSION}..."
wget -O "$TMP_DEB" "$URL"

# ================================
# INSTALL
# ===================================
log "Installing touchegg..."
sudo apt install -y "$TMP_DEB"

# ================================
# DONE
# ===================================
success "touchegg ${LATEST_VERSION} installed successfully!"
