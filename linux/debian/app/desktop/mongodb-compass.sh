#!/usr/bin/env bash
set -euo pipefail

# ===================================
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

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
VERSION="1.46.3"
URL="https://downloads.mongodb.com/compass/mongodb-compass_${VERSION}_${ARCH}.deb"
TMP_DEB="$(mktemp --suffix=.deb)"
DESKTOP_FILE="/usr/share/applications/mongodb-compass.desktop"
EXTRA_FLAGS='--password-store="gnome-libsecret" --ignore-additional-command-line-flags'

# ===================================
# DOWNLOAD
# ===================================
log "Downloading MongoDB Compass v$VERSION for $ARCH..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing MongoDB Compass..."
sudo apt install -y "$TMP_DEB"

# ===================================
# PATCH .DESKTOP LAUNCHER
# ===================================
log "Patching .desktop launcher with secure credential flags..."
if [[ -f "$DESKTOP_FILE" ]]; then
	sudo sed -i -E "s|^(Exec=.*mongodb-compass)(.*)|\1 ${EXTRA_FLAGS}|" "$DESKTOP_FILE"
	success "Desktop entry updated with flags:"
	echo -e "${YELLOW}  $EXTRA_FLAGS${NC}"
else
	warn "Desktop file not found: $DESKTOP_FILE"
fi

success "MongoDB Compass installed successfully!"
