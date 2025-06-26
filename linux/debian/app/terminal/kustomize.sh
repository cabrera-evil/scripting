#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m'

# ===================================
# Logging
# ===================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ===================================
# Checks
# ===================================
for cmd in curl tar grep sed; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
ARCH="linux_amd64"
TMP_DIR="$(mktemp -d)"
BIN_PATH="/usr/local/bin/kustomize"

# ===================================
# Detect latest version
# ===================================
log "Detecting latest version of kustomize..."
LATEST_TAG=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep tag_name | sed -E 's/.*"v([0-9.]+)".*/\1/')
[ -z "$LATEST_TAG" ] && abort "Failed to detect latest version."

# ===================================
# Download and extract
# ===================================
FILENAME="kustomize_v${LATEST_TAG}_${ARCH}.tar.gz"
URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${LATEST_TAG}/${FILENAME}"

log "Downloading kustomize v${LATEST_TAG}..."
curl -sL "$URL" -o "${TMP_DIR}/${FILENAME}"

log "Extracting..."
tar -xf "${TMP_DIR}/${FILENAME}" -C "$TMP_DIR"

# ===================================
# Install
# ===================================
log "Installing to ${BIN_PATH}..."
sudo mv "${TMP_DIR}/kustomize" "$BIN_PATH"
sudo chmod +x "$BIN_PATH"

# ===================================
# Done
# ===================================
success "kustomize v${LATEST_TAG} installed successfully."
