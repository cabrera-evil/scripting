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
# DETECT VERSION AND ARCHITECTURE
# ================================
log "Fetching latest draw.io Desktop release..."
API_URL="https://api.github.com/repos/jgraph/drawio-desktop/releases/latest"
RELEASE_JSON="$(curl -fsSL "$API_URL")" || die "Unable to reach GitHub API."
TAG="$(printf '%s' "$RELEASE_JSON" | jq -r '.tag_name // empty')" || die "Unable to determine latest tag."
[[ -n "$TAG" ]] || die "Unable to determine latest tag."
VERSION="${TAG#v}"

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
amd64 | arm64) PKG_ARCH="$ARCH" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

FILENAME="drawio-${PKG_ARCH}-${VERSION}.deb"
DOWNLOAD_URL="$(printf '%s' "$RELEASE_JSON" | jq -r --arg filename "$FILENAME" '.assets[] | select(.name == $filename) | .browser_download_url')" || die "Unable to find $FILENAME in the latest release."
[[ -n "$DOWNLOAD_URL" ]] || die "Unable to find $FILENAME in the latest release."
SHA_FILENAME="Files-SHA256-Hashes.txt"
SHA_URL="$(printf '%s' "$RELEASE_JSON" | jq -r --arg filename "$SHA_FILENAME" '.assets[] | select(.name == $filename) | .browser_download_url')" || die "Unable to find $SHA_FILENAME in the latest release."
[[ -n "$SHA_URL" ]] || die "Unable to find $SHA_FILENAME in the latest release."
TMP_DEB="$(mktemp --suffix=.deb)"
TMP_SHA="$(mktemp --suffix=.sha256)"

log "Detected version: ${BOLD}${VERSION}${NC}"
log "Architecture: ${BOLD}${PKG_ARCH}${NC}"
log "Downloading package: $FILENAME"
wget -O "$TMP_DEB" "$DOWNLOAD_URL"

# ================================
# VERIFY CHECKSUM
# ================================
log "Downloading checksum and verifying..."
wget -O "$TMP_SHA" "$SHA_URL"
EXPECTED_HASH="$(grep -F "  $FILENAME" "$TMP_SHA" | awk '{print $1}')"
[[ -n "$EXPECTED_HASH" ]] || die "Checksum not found for $FILENAME."
echo "${EXPECTED_HASH}  $TMP_DEB" | sha256sum -c -

# ================================
# INSTALL
# ================================
log "Installing draw.io Desktop..."
sudo apt install -y "$TMP_DEB"

success "draw.io Desktop ${VERSION} installed successfully!"
