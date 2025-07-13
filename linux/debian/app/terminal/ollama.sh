#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

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
for cmd in curl sudo systemctl tee; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Install Ollama
# ===================================
log "Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh
success "Ollama installation complete!"

# ===================================
# Configure systemd override
# ===================================
log "Configuring OLLAMA_HOST environment variable..."

sudo mkdir -p /etc/systemd/system/ollama.service.d

sudo tee /etc/systemd/system/ollama.service.d/override.conf >/dev/null <<EOF
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
EOF

success "Systemd override written to /etc/systemd/system/ollama.service.d/override.conf"

# ===================================
# Reload systemd and restart Ollama
# ===================================
log "Reloading systemd and restarting Ollama service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart ollama
success "Ollama service restarted with new environment variable!"
