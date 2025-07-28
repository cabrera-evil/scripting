#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

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

# ===================================
# CHECKS
# ===================================
for cmd in curl sudo systemctl tee; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# INSTALL OLLAMA
# ===================================
log "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh
success "Ollama installation complete!"

# ===================================
# CONFIGURE SYSTEMD OVERRIDE
# ===================================
log "Configuring OLLAMA_HOST environment variable..."

sudo mkdir -p /etc/systemd/system/ollama.service.d

sudo tee /etc/systemd/system/ollama.service.d/override.conf >/dev/null <<EOF
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
EOF

success "Systemd override written to /etc/systemd/system/ollama.service.d/override.conf"

# ===================================
# RELOAD SYSTEMD AND RESTART OLLAMA
# ===================================
log "Reloading systemd and restarting Ollama service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart ollama
success "Ollama service restarted with new environment variable!"
