#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# DETECT ARCHITECTURE
# ================================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="linux-x86_64" ;;
aarch64) ARCH="linux-aarch64" ;;
*) die "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# DETECT LATEST VERSION
# ================================
log "Fetching latest CMake version..."
VERSION=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest |
	grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')
[ -z "$VERSION" ] && die "Unable to determine latest CMake version."

# ===============================
# CONFIG
# ================================
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/cmake-${VERSION}.sh"
INSTALL_DIR="/opt/cmake-${VERSION}"
BIN_PATH="${INSTALL_DIR}/bin/cmake"
SYMLINK="/usr/local/bin/cmake"
URL="https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}-${ARCH}.sh"

# ===============================
# SKIP IF ALREADY INSTALLED
# ================================
if [[ -x "$BIN_PATH" ]]; then
	success "CMake ${VERSION} is already installed at ${BIN_PATH}"
	exit 0
fi

# ===============================
# DOWNLOAD
# ================================
log "Downloading CMake v${VERSION} for ${ARCH}..."
wget -O "$TMP_FILE" "$URL"
chmod +x "$TMP_FILE"

# ===============================
# INSTALL
# ================================
log "Installing to ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo chown "$USER:$USER" "$INSTALL_DIR"
sudo "$TMP_FILE" --prefix="$INSTALL_DIR" --skip-license

# ===============================
# SYMLINK
# ================================
log "Linking cmake to ${SYMLINK}..."
sudo ln -sf "$BIN_PATH" "$SYMLINK"

# ===============================
# DONE
# ================================
success "CMake v${VERSION} installed successfully."
