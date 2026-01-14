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
log "Fetching latest Freelens release..."
API_URL="https://api.github.com/repos/freelensapp/freelens/releases/latest"
RELEASE_JSON=$(curl -sL "$API_URL") || die "Unable to reach GitHub API."
TAG=$(printf "%s" "$RELEASE_JSON" | jq -r '.tag_name // empty') || TAG=""
[[ -z "$TAG" || "$TAG" == "null" ]] && die "Unable to determine latest tag."
VERSION="${TAG#v}"

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
amd64) PKG_ARCH="amd64" ;;
arm64) PKG_ARCH="arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

FILENAME="Freelens-${VERSION}-linux-${PKG_ARCH}.deb"
SHA_FILENAME="${FILENAME}.sha256"
DOWNLOAD_URL="https://github.com/freelensapp/freelens/releases/download/${TAG}/${FILENAME}"
SHA_URL="https://github.com/freelensapp/freelens/releases/download/${TAG}/${SHA_FILENAME}"
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
EXPECTED_HASH=$(grep -Eo '[a-f0-9]{64}' "$TMP_SHA" | head -n1)
[[ -z "$EXPECTED_HASH" ]] && die "Checksum not found in ${SHA_FILENAME}."
echo "${EXPECTED_HASH}  $TMP_DEB" | sha256sum -c -

# ================================
# INSTALL
# ================================
log "Installing Freelens..."
sudo apt install -y "$TMP_DEB"

success "Freelens ${VERSION} installed successfully!"
