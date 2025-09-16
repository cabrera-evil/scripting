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
for cmd in wget sudo dpkg apt sed; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

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
