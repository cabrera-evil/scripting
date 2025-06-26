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
for cmd in curl jq wget dpkg; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

# ===================================
# Fetch latest Docker Desktop version
# ===================================
log "Detecting latest Docker Desktop version for $ARCH..."
VERSION=$(curl -s "https://desktop.docker.com/linux/main/$ARCH/versions.json" | jq -r '.[0].version') || abort "Failed to fetch Docker Desktop version"
URL="https://desktop.docker.com/linux/main/$ARCH/${VERSION}/docker-desktop-${ARCH}.deb"

# ===================================
# Setup Docker APT Repository
# ===================================
log "Setting up Docker repository..."
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $CODENAME stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update -y

# ===================================
# Install Docker Engine
# ===================================
log "Installing Docker Engine components..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ===================================
# Download Docker Desktop
# ===================================
TMP_DEB="$(mktemp --suffix=.deb)"
log "Downloading Docker Desktop $VERSION..."
wget -q --show-progress -O "$TMP_DEB" "$URL"

# ===================================
# Install Docker Desktop
# ===================================
log "Installing Docker Desktop..."
sudo apt install -y "$TMP_DEB"

# ===================================
# Post-installation steps
# ===================================
log "Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

log "Enabling Docker services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

success "Docker Desktop $VERSION installed successfully. Please reboot or re-login for group changes to take effect."
