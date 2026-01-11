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
# SCRIPT CONFIGURATION
# ================================
REPO="localstack/localstack-cli"
BIN_NAME="localstack"
INSTALL_DIR="/usr/local/lib/localstack"
BIN_PATH="/usr/local/bin/${BIN_NAME}"
TMP_DIR="$(mktemp -d)"

# ================================
# DETECT ARCHITECTURE
# ================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="amd64" ;;
aarch64) ARCH="arm64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

# ================================
# DETECT LATEST VERSION
# ================================
log "Fetching latest LocalStack CLI version..."
VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep -Po '"tag_name":\s*"v\K[^\"]+')
[ -z "$VERSION" ] && die "Unable to detect latest version."

# ================================
# DOWNLOAD AND INSTALL
# ================================
FILENAME="localstack-cli-${VERSION}-linux-${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${FILENAME}"

log "Downloading LocalStack CLI v${VERSION}..."
curl -L "$URL" -o "${TMP_DIR}/${FILENAME}"

log "Extracting..."
tar -xzf "${TMP_DIR}/${FILENAME}" -C "$TMP_DIR"

BIN_CANDIDATE="$(find "$TMP_DIR" -type f -name "$BIN_NAME" -perm -u+x | head -n 1 || true)"
[ -z "$BIN_CANDIDATE" ] && die "Expected ${BIN_NAME} binary not found in archive."

BIN_DIR="$(dirname "$BIN_CANDIDATE")"

log "Installing to ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo cp -R "${BIN_DIR}/." "$INSTALL_DIR"
sudo chmod +x "${INSTALL_DIR}/${BIN_NAME}"

log "Linking binary to ${BIN_PATH}..."
sudo ln -sf "${INSTALL_DIR}/${BIN_NAME}" "$BIN_PATH"

# ================================
# DONE
# ================================
success "LocalStack CLI v${VERSION} installed successfully."
