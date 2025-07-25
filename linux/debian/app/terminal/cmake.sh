#!/usr/bin/env bash
set -euo pipefail

# ===============================
# Colors
# ===============================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===============================
# Logging
# ===============================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
	echo -e "${RED}✗ $1${NC}" >&2
	exit 1
}

# ===============================
# Checks
# ===============================
for cmd in wget curl sudo; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===============================
# Detect Architecture
# ===============================
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="linux-x86_64" ;;
aarch64) ARCH="linux-aarch64" ;;
*) abort "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# Detect Latest Version
# ===============================
log "Fetching latest CMake version..."
VERSION=$(curl -s https://api.github.com/repos/Kitware/CMake/releases/latest |
	grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')
[ -z "$VERSION" ] && abort "Unable to determine latest CMake version."

# ===============================
# Config
# ===============================
TMP_DIR="$(mktemp -d)"
TMP_FILE="${TMP_DIR}/cmake-${VERSION}.sh"
INSTALL_DIR="/opt/cmake-${VERSION}"
BIN_PATH="${INSTALL_DIR}/bin/cmake"
SYMLINK="/usr/local/bin/cmake"
URL="https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}-${ARCH}.sh"

# ===============================
# Skip if already installed
# ===============================
if [[ -x "$BIN_PATH" ]]; then
	success "CMake ${VERSION} is already installed at ${BIN_PATH}"
	exit 0
fi

# ===============================
# Download
# ===============================
log "Downloading CMake v${VERSION} for ${ARCH}..."
wget -O "$TMP_FILE" "$URL"
chmod +x "$TMP_FILE"

# ===============================
# Install
# ===============================
log "Installing to ${INSTALL_DIR}..."
sudo mkdir -p "$INSTALL_DIR"
sudo chown "$USER:$USER" "$INSTALL_DIR"
sudo "$TMP_FILE" --prefix="$INSTALL_DIR" --skip-license

# ===============================
# Symlink
# ===============================
log "Linking cmake to ${SYMLINK}..."
sudo ln -sf "$BIN_PATH" "$SYMLINK"

# ===============================
# Done
# ===============================
success "CMake v${VERSION} installed successfully."
