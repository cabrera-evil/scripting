#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]]; then
	readonly RED=$'\033[0;31m'
	readonly GREEN=$'\033[0;32m'
	readonly YELLOW=$'\033[0;33m'
	readonly BLUE=$'\033[0;34m'
	readonly MAGENTA=$'\033[0;35m'
	readonly BOLD=$'\033[1m'
	readonly DIM=$'\033[2m'
	readonly NC=$'\033[0m'
else
	readonly RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
QUIET=false
DEBUG=false

# ===================================
# LOGGING FUNCTIONS
# ===================================
log() { [[ "$QUIET" != true ]] && printf "${BLUE}▶${NC} %s\n" "$*" || true; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() { [[ "$QUIET" != true ]] && printf "${GREEN}✓${NC} %s\n" "$*" || true; }
debug() { [[ "$DEBUG" == true ]] && printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2 || true; }
die() {
	error "$*"
	exit 1
}

ARCH="$(dpkg --print-architecture)"
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

# ===================================
# FETCH LATEST DOCKER DESKTOP VERSION
# ===================================
log "Detecting latest Docker Desktop version for $ARCH..."
VERSION=$(curl -s "https://desktop.docker.com/linux/main/$ARCH/versions.json" | jq -r '.[0].version') || die "Failed to fetch Docker Desktop version"
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
