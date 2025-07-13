#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

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
for cmd in curl gpg sudo apt install; do
	command -v "${cmd%% *}" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# Setup repository
# ===================================
log "Setting up Docker repository..."
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

ARCH=$(dpkg --print-architecture)
CODENAME=$(source /etc/os-release && echo "$VERSION_CODENAME")

echo \
	"deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${CODENAME} stable" |
	sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update -y

# ===================================
# Install Docker components
# ===================================
log "Installing Docker Engine and components..."
sudo apt install -y \
	docker-ce \
	docker-ce-cli \
	containerd.io \
	docker-buildx-plugin \
	docker-compose-plugin

# ===================================
# Post-install setup
# ===================================
log "Adding current user to docker group..."
sudo usermod -aG docker "$USER"

# ===================================
# Update /etc/hosts
# ===================================
log "Ensuring 'host.docker.internal' is in /etc/hosts..."

if grep -qE '^127\.0\.0\.1\s+.*localhost' /etc/hosts; then
	if ! grep -qE '^127\.0\.0\.1\s+.*\bhost\.docker\.internal\b' /etc/hosts; then
		sudo sed -i -E 's/^(127\.0\.0\.1\s+.*\blocalhost\b)(.*)/\1 host.docker.internal\2/' /etc/hosts
		success "'host.docker.internal' added to 127.0.0.1 entry in /etc/hosts."
	else
		success "'host.docker.internal' is already present in /etc/hosts."
	fi
else
	abort "No '127.0.0.1 localhost' entry found in /etc/hosts. Please add one manually."
fi

# ==================================
# Enable Docker services
# ==================================
log "Enabling Docker and containerd services..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

success "Docker installation and configuration complete!"
