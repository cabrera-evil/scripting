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
# DETECT DEBIAN/UBUNTU CODENAME
# ================================
CODENAME=$(lsb_release -sc 2>/dev/null || echo "")
[[ -z "$CODENAME" ]] && die "Unable to detect Debian/Ubuntu codename. Is lsb_release installed?"

log "Detected codename: ${BOLD}${CODENAME}${NC}"

# ================================
# FETCH RELEASES AND FIND PACKAGE
# ================================
log "Fetching Jellyfin Media Player releases..."
API_URL="https://api.github.com/repos/jellyfin/jellyfin-desktop/releases"
RELEASES_JSON=$(curl -sL "$API_URL") || die "Unable to reach GitHub API."

# Try to find a release with the package for this codename
FOUND=false
TAG=""
VERSION=""
DOWNLOAD_URL=""

# Iterate through releases (latest first) to find one with our codename package
for release in $(echo "$RELEASES_JSON" | jq -r '.[].tag_name'); do
	debug "Checking release: $release"

	# Construct expected filename
	VERSION="${release#v}"
	FILENAME="jellyfin-media-player_${VERSION}-${CODENAME}.deb"

	# Check if this asset exists in the release
	ASSET_URL=$(echo "$RELEASES_JSON" | jq -r --arg tag "$release" --arg filename "$FILENAME" \
		'.[] | select(.tag_name == $tag) | .assets[] | select(.name == $filename) | .browser_download_url')

	if [[ -n "$ASSET_URL" && "$ASSET_URL" != "null" ]]; then
		log "Found package in release ${BOLD}${release}${NC}"
		TAG="$release"
		DOWNLOAD_URL="$ASSET_URL"
		FOUND=true
		break
	fi
done

if [[ "$FOUND" != true ]]; then
	die "No Jellyfin Media Player package found for codename '${CODENAME}'. Supported codenames: bookworm, jammy, noble, oracular, trixie"
fi

# ================================
# DOWNLOAD
# ================================
TMP_DEB="$(mktemp --suffix=.deb)"
FILENAME="jellyfin-media-player_${VERSION}-${CODENAME}.deb"

log "Downloading ${FILENAME}..."
wget -O "$TMP_DEB" "$DOWNLOAD_URL"

# ================================
# INSTALL
# ================================
log "Installing Jellyfin Media Player..."
sudo apt install -y "$TMP_DEB"

success "Jellyfin Media Player ${VERSION} installed successfully!"
