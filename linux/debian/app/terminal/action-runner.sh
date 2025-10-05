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
# DETECT LATEST VERSION AND HASH
# ================================
log "Detecting latest GitHub Actions Runner release..."
RELEASE_API="https://api.github.com/repos/actions/runner/releases/latest"
RELEASE_DATA=$(curl -s "$RELEASE_API")

RUNNER_VERSION=$(echo "$RELEASE_DATA" | jq -r '.tag_name' | sed 's/^v//')
ASSET_INFO=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | test("linux-x64.*\\.tar\\.gz$"))')
FILENAME=$(echo "$ASSET_INFO" | jq -r '.name')
DOWNLOAD_URL=$(echo "$ASSET_INFO" | jq -r '.browser_download_url')

# Get expected hash (from the release body)
EXPECTED_HASH=$(echo "$RELEASE_DATA" | jq -r '.body' | grep -i "${FILENAME}" | grep -oE '[a-f0-9]{64}' || true)
[ -z "$EXPECTED_HASH" ] && die "Could not extract SHA-256 hash for ${FILENAME}"

# ================================
# PATHS
# ================================
TMP_TAR="$(mktemp --suffix=.tar.gz)"
INSTALL_DIR="/usr/local/actions-runner"

# ================================
# DOWNLOAD
# ================================
log "Downloading GitHub Actions Runner ${RUNNER_VERSION}..."
wget -O "$TMP_TAR" "$DOWNLOAD_URL"

# ================================
# VERIFY HASH
# ================================
log "Verifying SHA-256 checksum..."
echo "${EXPECTED_HASH}  ${TMP_TAR}" | shasum -a 256 -c - || die "Checksum verification failed!"

# ================================
# EXTRACT
# ================================
log "Creating destination directory at ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"

log "Extracting runner package..."
sudo tar -xzf "$TMP_TAR" -C "$INSTALL_DIR"

success "GitHub Actions Runner ${RUNNER_VERSION} setup complete in '${INSTALL_DIR}'"
