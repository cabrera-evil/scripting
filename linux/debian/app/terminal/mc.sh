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
# SCRIPT CONFIG
# ================================
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
amd64) MC_ARCH="amd64" ;;
arm64) MC_ARCH="arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

URL="https://dl.min.io/client/mc/release/linux-${MC_ARCH}/mc"
TMP_DIR="$(mktemp -d)"
TMP_BIN="${TMP_DIR}/mc"
INSTALL_PATH="/usr/local/bin/mc"

cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# ================================
# DOWNLOAD
# ================================
log "Downloading MinIO Client (mc) for ${ARCH}..."
wget -O "$TMP_BIN" "$URL" || die "Failed to download mc."

# ================================
# INSTALL
# ================================
log "Installing mc to ${INSTALL_PATH}..."
sudo install -m 0755 "$TMP_BIN" "$INSTALL_PATH" || die "Failed to install mc."

# ================================
# VERIFY
# ================================
log "Verifying mc installation..."
"$INSTALL_PATH" --help >/dev/null || die "mc verification failed."

success "mc installed successfully. Use 'mc --help' to verify."
