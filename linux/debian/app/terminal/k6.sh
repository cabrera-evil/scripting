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
fi # No Color

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
# CONFIG
# ================================
INSTALL_DIR="/usr/local/bin"
TEMP_DIR=$(mktemp -d)

# Cleanup on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# ================================
# DETECT ARCHITECTURE
# ================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64)
	K6_ARCH="amd64"
	;;
aarch64 | arm64)
	K6_ARCH="arm64"
	;;
*)
	die "Unsupported architecture: $ARCH"
	;;
esac

# ================================
# DETECT LATEST VERSION
# ================================
log "Fetching latest k6 version..."
K6_VERSION=$(curl -s https://api.github.com/repos/grafana/k6/releases/latest | grep -Po '"tag_name": *"\K[^"]*')
[ -z "$K6_VERSION" ] && die "Unable to detect latest version."

# ================================
# DOWNLOAD
# ================================
FILENAME="k6-${K6_VERSION}-linux-${K6_ARCH}.tar.gz"
CHECKSUM_FILE="k6-${K6_VERSION}-checksums.txt"
URL="https://github.com/grafana/k6/releases/download/${K6_VERSION}/${FILENAME}"
CHECKSUM_URL="https://github.com/grafana/k6/releases/download/${K6_VERSION}/${CHECKSUM_FILE}"

log "Downloading k6 ${K6_VERSION} for ${K6_ARCH}..."
if ! curl -fsSL -o "${TEMP_DIR}/${FILENAME}" "$URL"; then
	die "Failed to download k6 from $URL"
fi

log "Downloading checksums..."
if ! curl -fsSL -o "${TEMP_DIR}/${CHECKSUM_FILE}" "$CHECKSUM_URL"; then
	die "Failed to download checksums from $CHECKSUM_URL"
fi

# ================================
# VERIFY CHECKSUM
# ================================
log "Verifying checksum..."
cd "$TEMP_DIR"
grep "${FILENAME}" "${CHECKSUM_FILE}" | sha256sum -c - || die "Checksum verification failed"

# ================================
# EXTRACT
# ================================
log "Extracting k6..."
tar -xzf "$FILENAME" || die "Failed to extract archive"

# ================================
# INSTALL
# ================================
log "Installing k6 to ${INSTALL_DIR}..."
sudo install -m 0755 "k6-${K6_VERSION}-linux-${K6_ARCH}/k6" "$INSTALL_DIR/k6" || die "Failed to install k6"

# ================================
# VERIFY INSTALLATION
# ================================
if command -v k6 &>/dev/null; then
	VERSION=$(k6 version)
	success "k6 installed successfully: $VERSION"
else
	die "k6 installation failed"
fi
