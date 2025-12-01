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
	BOLD=$'\033[1m'
	DIM=$'\033[2m'
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' BOLD='' DIM='' NC=''
fi # No Color

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false
FLAVOR="proprietary" # or "open"

# ================================
# LOGGING
# ================================
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
# ARGUMENT PARSING
# ================================
usage() {
	cat <<EOF
Usage: $0 [--quiet] [--debug]

Installs NVIDIA driver on Debian 13 "Trixie" following the Debian Wiki steps.

Options:
  --quiet    Reduce output
  --debug    Increase output
  -h, --help Show this help
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--quiet) QUIET=true ;;
	--debug) DEBUG=true ;;
	-h | --help)
		usage
		exit 0
		;;
	*) die "Unknown option: $1" ;;
	esac
	shift
done

# ================================
# USER INPUT FUNCTION
# ================================
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

prompt_flavor() {
	if prompt_yes_no "Install the open driver flavor (nvidia-open-kernel-dkms) instead of proprietary?"; then
		FLAVOR="open"
	else
		FLAVOR="proprietary"
	fi
}

# ================================
# INITIAL CHECKS
# ================================
[[ $EUID -eq 0 ]] && die "Do not run as root. Script will use sudo when needed."
log "Checking required commands..."
for cmd in lspci sudo apt tee dpkg; do
	command -v "$cmd" >/dev/null || die "Command '$cmd' not found"
done

if [[ -r /etc/os-release ]]; then
	. /etc/os-release
	if [[ "${VERSION_CODENAME:-}" != "trixie" ]]; then
		warn "Detected suite '${VERSION_CODENAME:-unknown}', but this script targets Debian 13 \"Trixie\"."
	fi
else
	warn "/etc/os-release not readable; cannot verify distribution."
fi

log "Detecting NVIDIA GPU..."
nvidia_gpu=$(lspci | grep -i nvidia | head -1) || die "No NVIDIA GPU detected"
success "Found: $nvidia_gpu"

# ================================
# CHECK EXISTING INSTALLATION
# ================================
if command -v nvidia-smi >/dev/null 2>&1; then
	success "NVIDIA driver already installed"
	nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits 2>/dev/null || true
	log "Verify with: nvidia-smi && glxinfo | grep 'OpenGL renderer'"
	exit 0
fi

# ================================
# FLAVOR SELECTION
# ================================
prompt_flavor
log "Selected driver flavor: ${FLAVOR}"

# ================================
# REPOSITORY VALIDATION
# ================================
check_components() {
	local file="$1"
	local missing=()
	for comp in main contrib non-free non-free-firmware; do
		if ! grep -Eq "^[[:space:]]*deb .*[[:space:]]${comp}([[:space:]]|$)" "$file"; then
			missing+=("$comp")
		fi
	done
	[[ ${#missing[@]} -eq 0 ]] || die "Missing components (${missing[*]}) in $file. Add main contrib non-free non-free-firmware before continuing."
}

if [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
	check_components /etc/apt/sources.list.d/debian.sources
elif [[ -f /etc/apt/sources.list ]]; then
	check_components /etc/apt/sources.list
else
	warn "Could not find /etc/apt/sources.list.d/debian.sources or /etc/apt/sources.list. Ensure repos include main contrib non-free non-free-firmware."
fi

warn "If Secure Boot is enabled, enroll your MOK before installing (see Debian Wiki)."
if [[ -d /etc/dracut.conf.d ]]; then
	warn "dracut detected; ensure /etc/dracut.conf.d/10-nvidia.conf includes modprobe configs as per Debian Wiki."
fi

# ================================
# SYSTEM PREPARATION
# ================================
log "Installing kernel headers for DKMS..."
sudo apt update
sudo apt install -y "linux-headers-$(dpkg --print-architecture)"

# ================================
# DRIVER INSTALLATION
# ================================
log "Updating package repositories..."
sudo apt update

log "Installing NVIDIA driver packages (${FLAVOR} flavor)..."
kernel_pkg="nvidia-kernel-dkms"
[[ "$FLAVOR" == "open" ]] && kernel_pkg="nvidia-open-kernel-dkms"

sudo apt install -y \
	"$kernel_pkg" \
	nvidia-driver \
	firmware-misc-nonfree \
	mesa-utils

success "NVIDIA driver installation completed"

# ================================
# REBOOT HANDLING
# ================================
warn "System reboot required to activate the driver"
log "After reboot, verify with:"
echo "  nvidia-smi"
echo "  nvidia-settings"
echo "  glxinfo | grep 'OpenGL renderer'"
echo "  cat /sys/module/nvidia_drm/parameters/modeset"
echo "  # If modeset is N, add: echo \"options nvidia-drm modeset=1\" | sudo tee /etc/modprobe.d/nvidia-options.conf"
if prompt_yes_no "Reboot now?"; then
	log "Rebooting..."
	sleep 1
	sudo reboot
else
	warn "Reboot manually with: sudo reboot"
	exit 0
fi
