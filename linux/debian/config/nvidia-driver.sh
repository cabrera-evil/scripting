#!/usr/bin/env bash
set -euo pipefail

# ================================
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
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}
# ================================
# USER INPUT FUNCTION
# ===================================
prompt_yes_no() {
	local prompt="$1"
	local response
	while true; do
		echo -e "${YELLOW}$prompt (y/N): ${NC}"
		read -r response
		case "$response" in
		[Yy] | [Yy][Ee][Ss]) return 0 ;;
		[Nn] | [Nn][Oo] | "") return 1 ;;
		*) echo -e "${RED}Please answer yes (y) or no (n).${NC}" ;;
		esac
	done
}

# ================================
# INITIAL CHECKS
# ===================================
[[ $EUID -eq 0 ]] && abort "Do not run as root. Script will use sudo when needed."
log "Checking required commands..."
for cmd in lspci sudo apt tee; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' not found"
done
log "Detecting NVIDIA GPU..."
nvidia_gpu=$(lspci | grep -i nvidia | head -1) || abort "No NVIDIA GPU detected"
success "Found: $nvidia_gpu"

# ================================
# CHECK EXISTING INSTALLATION
# ===================================
if command -v nvidia-smi >/dev/null 2>&1; then
	success "NVIDIA driver already installed"
	nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits 2>/dev/null || true
	log "Verify with: nvidia-smi && glxinfo | grep 'OpenGL renderer'"
	exit 0
fi

# ================================
# SYSTEM PREPARATION
# ===================================
log "Blacklisting Nouveau driver..."
if [[ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]]; then
	sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<'EOF'
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF
	success "Nouveau blacklisted"
else
	warn "Nouveau blacklist already exists"
fi
log "Updating initramfs..."
sudo update-initramfs -u || abort "Failed to update initramfs"

# ================================
# DRIVER INSTALLATION
# ===================================
log "Updating package repositories..."
sudo apt update || abort "Failed to update package list"
log "Installing NVIDIA driver packages..."
sudo apt install -y \
	nvidia-driver \
	nvidia-settings \
	firmware-misc-nonfree \
	mesa-utils || abort "Failed to install NVIDIA packages"
success "NVIDIA driver installation completed"

# ================================
# REBOOT HANDLING
# ===================================
warn "System reboot required to activate the driver"
log "After reboot, verify with:"
echo "  nvidia-smi"
echo "  nvidia-settings"
echo "  glxinfo | grep 'OpenGL renderer'"
if prompt_yes_no "Reboot now?"; then
	log "Rebooting..."
	sleep 1
	sudo reboot
else
	warn "Reboot manually with: sudo reboot"
	exit 0
fi
