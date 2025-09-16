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
for cmd in wget sudo dpkg apt; do
    command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
URL="https://dl.google.com/linux/direct/google-chrome-stable_current_${ARCH}.deb"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading Google Chrome for ${ARCH}..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing Google Chrome..."
sudo apt install -y "$TMP_DEB"

success "Google Chrome installed successfully!"
