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
for cmd in wget gpg sudo apt; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
ARCH="$(dpkg --print-architecture)"
GPG_URL="https://apt.releases.hashicorp.com/gpg"
KEYRING_PATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"

# ===================================
# INSTALL PREREQUISITES
# ===================================
log "Updating package list and installing prerequisites..."
sudo apt update && sudo apt install -y gnupg software-properties-common

# ===================================
# INSTALL GPG KEY
# ===================================
log "Installing HashiCorp GPG key..."
wget -O- "$GPG_URL" |
	gpg --dearmor |
	sudo tee "$KEYRING_PATH" >/dev/null

# ===================================
# VERIFY GPG KEY
# ===================================
log "Verifying GPG key fingerprint..."
gpg --no-default-keyring \
	--keyring "$KEYRING_PATH" \
	--fingerprint

# ===================================
# ADD REPOSITORY
# ===================================
log "Adding HashiCorp repository..."
echo "deb [arch=$ARCH signed-by=$KEYRING_PATH] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# ===================================
# UPDATE PACKAGE LIST
# ===================================
log "Updating package list with HashiCorp repository..."
sudo apt update

# ===================================
# INSTALL TERRAFORM
# ===================================
log "Installing Terraform..."
sudo apt install terraform

success "Terraform installed successfully!"
