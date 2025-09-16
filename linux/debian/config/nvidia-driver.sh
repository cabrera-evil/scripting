#!/usr/bin/env bash
set -euo pipefail

# ================================
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
# LOGGING
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
[[ $EUID -eq 0 ]] && die "Do not run as root. Script will use sudo when needed."
log "Checking required commands..."
for cmd in lspci sudo apt tee; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' not found"
done
log "Detecting NVIDIA GPU..."
nvidia_gpu=$(lspci | grep -i nvidia | head -1) || die "No NVIDIA GPU detected"
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
	log "Updating initramfs..."
	sudo update-initramfs -u || die "Failed to update initramfs"
	success "Nouveau blacklisted"
else
	warn "Nouveau blacklist already exists"
fi

# ================================
# DRIVER INSTALLATION
# ===================================
log "Updating package repositories..."
sudo apt update
log "Installing NVIDIA driver packages..."
sudo apt install -y \
	linux-headers-amd64 \
	nvidia-detect \
	nvidia-driver \
	nvidia-settings \
	firmware-misc-nonfree \
	mesa-utils \
	bumblebee \
	primus
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
