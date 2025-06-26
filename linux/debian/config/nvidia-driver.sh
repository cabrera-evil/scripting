#!/usr/bin/env bash
set -euo pipefail

# ================================
# Colors
# ================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ================================
# Logging
# ================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}! $1${NC}"; }
abort() {
    echo -e "${RED}✗ $1${NC}" >&2
    exit 1
}

# ================================
# Checks
# ================================
for cmd in lspci sudo apt tee update-initramfs; do
    command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ================================
# Detect NVIDIA GPU
# ================================
log "Checking for NVIDIA GPU..."
if ! lspci | grep -i nvidia >/dev/null; then
    abort "No NVIDIA GPU detected."
fi

# ================================
# Check if drivers already installed
# ================================
if command -v nvidia-smi >/dev/null 2>&1; then
    success "NVIDIA driver already installed."
    log "You can verify with:"
    echo "  nvidia-smi"
    echo "  glxinfo | grep 'OpenGL renderer'"
    exit 0
fi

# ================================
# Blacklist Nouveau
# ================================
log "Blacklisting Nouveau driver..."
sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<EOF
blacklist nouveau
options nouveau modeset=0
EOF

log "Updating initramfs..."
sudo update-initramfs -u

# ================================
# Install NVIDIA drivers
# ================================
log "Updating APT package list..."
sudo apt update

log "Installing NVIDIA driver and firmware..."
sudo apt install -y nvidia-driver firmware-misc-nonfree mesa-utils

success "NVIDIA driver installation completed."
warn "A reboot is required to activate the driver."

log "After reboot, verify with:"
echo "  nvidia-smi"
echo "  glxinfo | grep 'OpenGL renderer'"

# ================================
# Prompt to reboot
# ================================
read -rp $'\nDo you want to reboot now? [Y/n]: ' confirm
if [[ "$confirm" =~ ^[Yy]$ || -z "$confirm" ]]; then
    log "Rebooting..."
    sudo reboot
else
    warn "Please reboot manually to apply the changes."
fi
