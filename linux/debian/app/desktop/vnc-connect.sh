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

# ===================================
# CHECKS
# ===================================
for cmd in wget curl grep sed sudo dpkg apt; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION
# ===================================
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

# ===================================
# DOWNLOAD
# ===================================
log "Downloading RealVNC Connect v$VERSION..."
wget -O "$TMP_DEB" "$DEB_URL"

# ===================================
# INSTALL
# ===================================
log "Installing RealVNC Connect..."
sudo apt install -y "$TMP_DEB"

success "RealVNC Connect v$VERSION installed successfully!"
