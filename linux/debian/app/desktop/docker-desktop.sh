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
for cmd in curl jq wget dpkg; do
  command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

# ===================================
# FETCH LATEST DOCKER DESKTOP VERSION
# ===================================
log "Detecting latest Docker Desktop version for $ARCH..."
VERSION=$(curl -s "https://desktop.docker.com/linux/main/$ARCH/versions.json" | jq -r '.[0].version') || abort "Failed to fetch Docker Desktop version"
URL="https://desktop.docker.com/linux/main/$ARCH/${VERSION}/docker-desktop-${ARCH}.deb"

# ===================================
# SETUP DOCKER APT REPOSITORY
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
# INSTALL DOCKER ENGINE
# ===================================
log "Installing Docker Engine components..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ===================================
# DOWNLOAD DOCKER DESKTOP
# ===================================
TMP_DEB="$(mktemp --suffix=.deb)"
log "Downloading Docker Desktop $VERSION..."
wget -O "$TMP_DEB" "$URL"

# ===================================
# INSTALL DOCKER DESKTOP
# ===================================
log "Installing Docker Desktop..."
sudo apt install -y "$TMP_DEB"

# ===================================
# POST-INSTALLATION STEPS
# ===================================
log "Adding user '$USER' to docker group..."
sudo usermod -aG docker "$USER"

log "Enabling Docker services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

success "Docker Desktop $VERSION installed successfully. Please reboot or re-login for group changes to take effect."
