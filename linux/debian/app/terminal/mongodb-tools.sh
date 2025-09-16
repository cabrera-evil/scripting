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
for cmd in curl grep wget dpkg sudo sed awk; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION
# ===================================
log "Detecting latest MongoDB Database Tools version..."
LATEST_VERSION=$(curl -s https://www.mongodb.com/try/download/database-tools |
	grep -oP 'mongodb-database-tools-debian12-[^"]+\.deb' |
	grep "$(uname -m)" |
	head -n1 |
	sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)\.deb/\1/')

[ -z "$LATEST_VERSION" ] && die "Could not detect latest version."

# ===================================
# CONFIG
# ===================================
ARCH="$(uname -m)"
PACKAGE="mongodb-database-tools-debian12-${ARCH}-${LATEST_VERSION}.deb"
URL="https://fastdl.mongodb.org/tools/db/${PACKAGE}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading MongoDB Database Tools v${LATEST_VERSION}..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing package..."
sudo apt install -y "$TMP_DEB"

success "MongoDB Database Tools v${LATEST_VERSION} installed successfully!"
