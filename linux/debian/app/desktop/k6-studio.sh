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
log "Fetching latest k6-studio release..."
API_URL="https://api.github.com/repos/grafana/k6-studio/releases/latest"
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

FILENAME="k6-studio_${VERSION}_${PKG_ARCH}.deb"
DOWNLOAD_URL="https://github.com/grafana/k6-studio/releases/download/${TAG}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

log "Detected version: ${BOLD}${VERSION}${NC}"
log "Architecture: ${BOLD}${PKG_ARCH}${NC}"
log "Downloading package: $FILENAME"
wget -O "$TMP_DEB" "$DOWNLOAD_URL"

# ================================
# VERIFY CHECKSUM
# ================================
log "Fetching checksums from release notes..."
# Try to extract checksum from release body
RELEASE_BODY=$(printf "%s" "$RELEASE_JSON" | jq -r '.body // empty' || echo "")
EXPECTED_HASH=$(echo "$RELEASE_BODY" | grep -i "$FILENAME" | grep -oP 'sha256:\s*\K[a-f0-9]{64}' || echo "")

if [[ -n "$EXPECTED_HASH" ]]; then
	log "Verifying checksum..."
	echo "${EXPECTED_HASH}  $TMP_DEB" | sha256sum -c - || die "Checksum verification failed!"
else
	warn "No checksum found in release notes for $FILENAME - skipping verification"
	warn "Please verify manually if security is a concern"
fi

# ================================
# INSTALL
# ================================
log "Installing k6-studio..."
sudo apt install -y "$TMP_DEB"

success "k6-studio ${VERSION} installed successfully!"
