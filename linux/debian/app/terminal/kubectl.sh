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
for cmd in wget sudo install dpkg; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Config
# ===================================
ARCH="$(dpkg --print-architecture)"
KUBECTL_VERSION="$(wget -qO- https://dl.k8s.io/release/stable.txt)"
URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"
TMP_BIN="$(mktemp)"

# ===================================
# Download
# ===================================
log "Downloading kubectl ${KUBECTL_VERSION} for ${ARCH}..."
wget -q --show-progress -O "$TMP_BIN" "$URL"

# ===================================
# Install
# ===================================
log "Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 "$TMP_BIN" /usr/local/bin/kubectl

# ===================================
# Autocompletion
# ===================================
log "Enabling bash autocompletion for kubectl..."
if ! grep -q "source <(kubectl completion bash)" ~/.bashrc; then
    echo "source <(kubectl completion bash)" >>~/.bashrc
fi

# ===================================
# Done
# ===================================
success "kubectl ${KUBECTL_VERSION} installed successfully."
