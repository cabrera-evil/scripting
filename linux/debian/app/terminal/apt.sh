#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
BLUE='\e[0;34m'
GREEN='\e[0;32m'
RED='\e[0;31m'
NC='\e[0m' # No Color

# ===================================
# Logging
# ===================================
log()     { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
abort()   { echo -e "${RED}✗ $1${NC}" >&2; exit 1; }

# ===================================
# Checks
# ===================================
for cmd in sudo apt; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Packages to install
# ===================================
packages=(
  bat
  bluez
  build-essential
  curl
  filezilla
  git
  git-flow
  htop
  lsd
  ncdu
  neofetch
  net-tools
  ranger
  resolvconf
  rsync
  tmux
  trash-cli
  unzip
  unrar
  vim
  wireguard
  xclip
  zsh
  zip
  wget
)

# ===================================
# Update and install
# ===================================
log "Updating package lists..."
sudo apt update -y

log "Installing selected packages..."
sudo apt install -y "${packages[@]}"

success "All packages installed successfully!"
