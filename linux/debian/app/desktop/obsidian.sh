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
# DETECT VERSION AND ARCHITECTURE
# ===================================
log "Fetching latest Obsidian version..."
API_URL="https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"
VERSION=$(curl -s "$API_URL" | jq -r .tag_name | sed 's/^v//') || die "Unable to retrieve version."
ARCH="$(dpkg --print-architecture)"
FILENAME="obsidian_${VERSION}_${ARCH}.deb"
DOWNLOAD_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

log "Detected version: v$VERSION"
log "Architecture: $ARCH"
log "Downloading: $FILENAME"

# ===================================
# DOWNLOAD
# ===================================
wget -O "$TMP_DEB" "$DOWNLOAD_URL"

# ===================================
# INSTALL
# ===================================
log "Installing Obsidian..."
sudo apt install -y "$TMP_DEB"

success "Obsidian v${VERSION} installed successfully!"
