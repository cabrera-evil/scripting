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
for cmd in curl tar grep sed uname; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===============================
# Config
# ===============================
ARCH=$(uname -m)
TMP_DIR="$(mktemp -d)"
BIN_PATH="/usr/local/bin/lazydocker"

# Map architecture
case "$ARCH" in
x86_64) ARCH="Linux_x86_64" ;;
aarch64) ARCH="Linux_arm64" ;;
*) abort "Unsupported architecture: $ARCH" ;;
esac

# ===============================
# Detect latest version
# ===============================
log "Fetching latest version of Lazydocker..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')
[ -z "$VERSION" ] && abort "Unable to determine latest version."

# ===============================
# Download
# ===============================
TARBALL="lazydocker_${VERSION}_${ARCH}.tar.gz"
URL="https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/${TARBALL}"

log "Downloading Lazydocker v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/${TARBALL}"

log "Extracting..."
tar -xzf "${TMP_DIR}/${TARBALL}" -C "$TMP_DIR"

# ===============================
# Install
# ===============================
log "Installing to ${BIN_PATH}..."
sudo mv "${TMP_DIR}/lazydocker" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# ===============================
# Done
# ===============================
success "Lazydocker v${VERSION} installed successfully."
