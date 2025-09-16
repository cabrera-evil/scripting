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
# LOGGING
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
for cmd in wget curl grep sed awk sudo dpkg apt lsb_release; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' is required but not found."
done

# ===================================
# DETECT LATEST VERSION
# ===================================
log "Fetching latest VirtualBox version..."
LATEST_VERSION=$(curl -fsSL https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT) || die "Could not retrieve latest version"
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

[ -z "$DEB_NAME" ] && die "Could not find a matching .deb for $LATEST_VERSION on $CODENAME/$ARCH"

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
wget -O "$TMP_DEB" "$URL" || die "Download failed: $URL"

# ===================================
# INSTALL
# ===================================
log "Installing VirtualBox..."
sudo apt install -y "$TMP_DEB" || die "Installation failed"

success "VirtualBox $LATEST_VERSION installed successfully!"
