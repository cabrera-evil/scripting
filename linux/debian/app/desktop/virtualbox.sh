#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
	if [ "$SILENT" != true ]; then
		echo -e "${BLUE}==> $1${NC}"
	fi
}
warn() {
	if [ "$SILENT" != true ]; then
		echo -e "${YELLOW}⚠️  $1${NC}" >&2
	fi
}
success() {
	if [ "$SILENT" != true ]; then
		echo -e "${GREEN}✓ $1${NC}"
	fi
}
abort() {
	if [ "$SILENT" != true ]; then
		echo -e "${RED}✗ $1${NC}" >&2
	fi
	exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in wget curl grep sed awk sudo dpkg apt lsb_release; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION
# ===================================
log "Fetching latest VirtualBox version..."
LATEST_VERSION=$(curl -fsSL https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT) || abort "Could not retrieve latest version"
ARCH="$(dpkg --print-architecture)"
CODENAME="$(lsb_release -sc)"

# Extract major.minor from full version (e.g., 7.1.12 -> 7.1)
SERIES="${LATEST_VERSION%.*}"

# Find the exact .deb filename for this version, codename, and architecture
log "Resolving download artifact for v$LATEST_VERSION on $CODENAME/$ARCH..."
DEB_NAME=$(
	curl -fsSL "https://download.virtualbox.org/virtualbox/${LATEST_VERSION}/" |
		LC_ALL=C grep -oP "virtualbox-${SERIES}_${LATEST_VERSION}-\d+~Debian~${CODENAME}_${ARCH}\.deb" |
		head -n1
)

[ -z "$DEB_NAME" ] && abort "Could not find a matching .deb for $LATEST_VERSION on $CODENAME/$ARCH"

# Extract build number from the filename (optional, for logging)
BUILD="$(printf '%s\n' "$DEB_NAME" | sed -n "s/^virtualbox-${SERIES}_${LATEST_VERSION}-\([0-9]\+\)~Debian~${CODENAME}_${ARCH}\.deb$/\1/p")"

# ===================================
# CONFIG
# ===================================
FILENAME="$DEB_NAME"
URL="https://download.virtualbox.org/virtualbox/${LATEST_VERSION}/${FILENAME}"
TMP_DEB="$(mktemp --suffix=.deb)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading VirtualBox $LATEST_VERSION (build ${BUILD:-unknown}) for $ARCH on $CODENAME..."
wget -O "$TMP_DEB" "$URL" || abort "Download failed: $URL"

# ===================================
# INSTALL
# ===================================
log "Installing VirtualBox..."
sudo apt install -y "$TMP_DEB" || abort "Installation failed"

success "VirtualBox $LATEST_VERSION installed successfully!"
