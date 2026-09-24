#!/usr/bin/env bash
set -euo pipefail

# ================================
# COLORS
# ================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m'
  MAGENTA=$'\033[0;35m'
  NC=$'\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' NC=''
fi # No Color

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false

# ================================
# LOGGING FUNCTIONS
# ================================
log() {
  if [[ "$QUIET" != true ]]; then
    printf "${BLUE}▶${NC} %s\n" "$*"
  fi
}
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() {
  if [[ "$QUIET" != true ]]; then
    printf "${GREEN}✓${NC} %s\n" "$*"
  fi
}
debug() {
  if [[ "$DEBUG" == true ]]; then
    printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2
  fi
}
die() {
  error "$*"
  exit 1
}

# ================================
# INSTALL OLLAMA
# ================================
if command -v ollama >/dev/null 2>&1; then
  success "Ollama is already installed at $(command -v ollama)."
  exit 0
fi

INSTALLER_SCRIPT="$(mktemp)"
trap 'rm -f "$INSTALLER_SCRIPT"' EXIT

log "Downloading Ollama installer..."
curl -fsSL https://ollama.com/install.sh -o "$INSTALLER_SCRIPT" || die "Failed to download Ollama installer."

log "Installing Ollama..."
sh "$INSTALLER_SCRIPT" || die "Failed to install Ollama."
success "Ollama installation complete!"

sudo systemctl daemon-reload

if ! systemctl cat ollama.service >/dev/null 2>&1; then
  warn "ollama.service was not found. Creating a systemd service for the existing Ollama binary."

  if ! id -u ollama >/dev/null 2>&1; then
    sudo useradd -r -s /bin/false -U -m -d /usr/share/ollama ollama
  fi

  sudo tee /etc/systemd/system/ollama.service >/dev/null <<EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=${OLLAMA_BIN} serve
User=ollama
Group=ollama
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

  success "Systemd service written to /etc/systemd/system/ollama.service"
fi

# ================================
# CONFIGURE SYSTEMD OVERRIDE
# ================================
log "Configuring OLLAMA_HOST environment variable..."

sudo mkdir -p /etc/systemd/system/ollama.service.d

sudo tee /etc/systemd/system/ollama.service.d/override.conf >/dev/null <<EOF
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"

# Keep the model loaded between requests to avoid reload latency.
Environment="OLLAMA_KEEP_ALIVE=1h"

# Better default for OpenCode / long coding sessions.
Environment="OLLAMA_CONTEXT_LENGTH=65536"

# Reduce memory usage for large contexts.
Environment="OLLAMA_FLASH_ATTENTION=1"

# Reduce KV-cache memory usage.
Environment="OLLAMA_KV_CACHE_TYPE=q8_0"

# Your RTX 4070 SUPER has 12 GB VRAM, so avoid loading multiple models.
Environment="OLLAMA_MAX_LOADED_MODELS=1"

# Prefer one active generation at a time when using 64K context.
Environment="OLLAMA_NUM_PARALLEL=1"

# Queue additional company requests instead of rejecting them immediately.
Environment="OLLAMA_MAX_QUEUE=64"

# Useful while tuning; disable later if logs get noisy.
Environment="OLLAMA_DEBUG=1"

# CUDA diagnostic verbosity.
Environment="CUDA_ERROR_LEVEL=50"
EOF

success "Systemd override written to /etc/systemd/system/ollama.service.d/override.conf"

# ================================
# RELOAD SYSTEMD AND RESTART OLLAMA
# ================================
log "Reloading systemd and restarting Ollama service..."
sudo systemctl daemon-reload
sudo systemctl enable --now ollama.service
sudo systemctl restart ollama.service
success "Ollama service restarted with new environment variable!"
