#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in curl wget shasum jq sudo tar; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION AND HASH
# ===================================
log "Detecting latest GitHub Actions Runner release..."
RELEASE_API="https://api.github.com/repos/actions/runner/releases/latest"
RELEASE_DATA=$(curl -s "$RELEASE_API")

RUNNER_VERSION=$(echo "$RELEASE_DATA" | jq -r '.tag_name' | sed 's/^v//')
ASSET_INFO=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | test("linux-x64.*\\.tar\\.gz$"))')
FILENAME=$(echo "$ASSET_INFO" | jq -r '.name')
DOWNLOAD_URL=$(echo "$ASSET_INFO" | jq -r '.browser_download_url')

# Get expected hash (from the release body)
EXPECTED_HASH=$(echo "$RELEASE_DATA" | jq -r '.body' | grep -i "${FILENAME}" | grep -oE '[a-f0-9]{64}' || true)
[ -z "$EXPECTED_HASH" ] && abort "Could not extract SHA-256 hash for ${FILENAME}"

# ===================================
# PATHS
# ===================================
TMP_TAR="$(mktemp --suffix=.tar.gz)"
INSTALL_DIR="/usr/local/actions-runner"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading GitHub Actions Runner ${RUNNER_VERSION}..."
wget -O "$TMP_TAR" "$DOWNLOAD_URL"

# ===================================
# VERIFY HASH
# ===================================
log "Verifying SHA-256 checksum..."
echo "${EXPECTED_HASH}  ${TMP_TAR}" | shasum -a 256 -c - || abort "Checksum verification failed!"

# ===================================
# EXTRACT
# ===================================
log "Creating destination directory at ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"

log "Extracting runner package..."
sudo tar -xzf "$TMP_TAR" -C "$INSTALL_DIR"

success "GitHub Actions Runner ${RUNNER_VERSION} setup complete in '${INSTALL_DIR}'"
