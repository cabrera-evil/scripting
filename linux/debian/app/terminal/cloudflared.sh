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
TEMP_DIR=$(mktemp -d)
INSTALL_PATH="/usr/local/bin/cloudflared"

trap 'rm -rf "$TEMP_DIR"' EXIT

# ================================
# DETECT ARCHITECTURE
# ================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64)
	CLOUDFLARED_ARCH="amd64"
	;;
aarch64 | arm64)
	CLOUDFLARED_ARCH="arm64"
	;;
armv7l | armv6l)
	CLOUDFLARED_ARCH="arm"
	;;
*)
	die "Unsupported architecture: $ARCH"
	;;
esac

FILENAME="cloudflared-linux-${CLOUDFLARED_ARCH}"
DOWNLOAD_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/${FILENAME}"
DOWNLOADED_FILE="${TEMP_DIR}/${FILENAME}"

# ================================
# DOWNLOAD
# ================================
log "Downloading cloudflared binary for ${CLOUDFLARED_ARCH}..."
if ! wget -O "$DOWNLOADED_FILE" "$DOWNLOAD_URL"; then
	die "Failed to download cloudflared from ${DOWNLOAD_URL}"
fi

# ================================
# INSTALL
# ================================
log "Installing cloudflared to ${INSTALL_PATH}..."
sudo cp "$DOWNLOADED_FILE" "$INSTALL_PATH" || die "Failed to copy cloudflared to ${INSTALL_PATH}"
sudo chmod +x "$INSTALL_PATH" || die "Failed to make ${INSTALL_PATH} executable"

# ================================
# VERIFY INSTALLATION
# ================================
if command -v cloudflared &>/dev/null; then
	VERSION=$(cloudflared -v)
	success "cloudflared installed successfully: ${VERSION}"
else
	die "cloudflared installation failed"
fi
