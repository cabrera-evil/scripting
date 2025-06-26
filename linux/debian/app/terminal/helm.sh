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
for cmd in curl tar grep uname chmod mv sudo; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Detect latest version
# ===================================
log "Detecting latest Helm version..."
LATEST=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep -oP '"tag_name":\s*"\Kv[0-9.]+' || true)
[[ -z "$LATEST" ]] && abort "Unable to detect latest version."

ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
OS=$(uname | tr '[:upper:]' '[:lower:]')
FILENAME="helm-${LATEST#v}-$OS-$ARCH.tar.gz"
TMP_DIR=$(mktemp -d)
URL="https://get.helm.sh/${FILENAME}"

# ===================================
# Download
# ===================================
log "Downloading Helm $LATEST..."
curl -fsSL "$URL" -o "$TMP_DIR/helm.tar.gz"

# ===================================
# Extract and Install
# ===================================
log "Extracting and installing Helm..."
tar -xzf "$TMP_DIR/helm.tar.gz" -C "$TMP_DIR"
sudo mv "$TMP_DIR/$OS-$ARCH/helm" /usr/local/bin/helm
sudo chmod +x /usr/local/bin/helm

# ===================================
# Autocompletion
# ===================================
log "Enabling bash autocompletion..."
if ! grep -q "source <(helm completion bash)" ~/.bashrc; then
    echo "source <(helm completion bash)" >>~/.bashrc
fi

success "Helm $LATEST installed successfully. Run with 'helm version'."
