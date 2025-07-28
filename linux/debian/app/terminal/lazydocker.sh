#!/usr/bin/env bash
set -euo pipefail

# ===============================
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

# ===============================
# CHECKS
# ===================================
for cmd in curl tar grep sed uname; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===============================
# CONFIG
# ===================================
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
# DETECT LATEST VERSION
# ===================================
log "Fetching latest version of Lazydocker..."
VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')
[ -z "$VERSION" ] && abort "Unable to determine latest version."

# ===============================
# DOWNLOAD
# ===================================
TARBALL="lazydocker_${VERSION}_${ARCH}.tar.gz"
URL="https://github.com/jesseduffield/lazydocker/releases/download/v${VERSION}/${TARBALL}"

log "Downloading Lazydocker v${VERSION}..."
curl -sL "$URL" -o "${TMP_DIR}/${TARBALL}"

log "Extracting..."
tar -xzf "${TMP_DIR}/${TARBALL}" -C "$TMP_DIR"

# ===============================
# INSTALL
# ===================================
log "Installing to ${BIN_PATH}..."
sudo mv "${TMP_DIR}/lazydocker" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# ===============================
# DONE
# ===================================
success "Lazydocker v${VERSION} installed successfully."
