#!/usr/bin/env bash
set -euo pipefail

# ===================================
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
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in wget sudo install dpkg; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
KUBECTL_VERSION="$(wget -qO- https://dl.k8s.io/release/stable.txt)"
URL="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"
TMP_BIN="$(mktemp)"

# ===================================
# DOWNLOAD
# ===================================
log "Downloading kubectl ${KUBECTL_VERSION} for ${ARCH}..."
wget -O "$TMP_BIN" "$URL"

# ===================================
# INSTALL
# ===================================
log "Installing kubectl to /usr/local/bin..."
sudo install -o root -g root -m 0755 "$TMP_BIN" /usr/local/bin/kubectl

# ===================================
# AUTOCOMPLETION
# ===================================
log "Enabling bash autocompletion for kubectl..."
if ! grep -q "source <(kubectl completion bash)" ~/.bashrc; then
	echo "source <(kubectl completion bash)" >>~/.bashrc
fi

# ===================================
# DONE
# ===================================
success "kubectl ${KUBECTL_VERSION} installed successfully."
