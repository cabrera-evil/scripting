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
else
  log "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
  success "Ollama installation complete!"
fi

OLLAMA_BIN=$(command -v ollama || true)
if [[ -z "$OLLAMA_BIN" ]]; then
  die "Ollama command was not found after installation."
fi

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
