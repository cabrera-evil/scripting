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
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' NC=''
fi

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false

# ================================
# LOGGING FUNCTIONS
# ================================
log() {
	if [[ "$QUIET" != true ]]; then
		printf "${BLUE}▶${NC} %s\n" "$*"
	fi
}
warn() { printf "${YELLOW}⚠${NC} %s\n" "$*" >&2; }
error() { printf "${RED}✗${NC} %s\n" "$*" >&2; }
success() {
	if [[ "$QUIET" != true ]]; then
		printf "${GREEN}✓${NC} %s\n" "$*"
	fi
}
debug() {
	if [[ "$DEBUG" == true ]]; then
		printf "${MAGENTA}⚈${NC} DEBUG: %s\n" "$*" >&2
	fi
}
die() {
	error "$*"
	exit 1
}

# ================================
# INSTALL QEMU AND LIBVIRT
# ================================
log "Updating package list..."
sudo apt update -y

log "Installing QEMU, libvirt, and virtualization tools..."
sudo apt install -y \
	qemu-system \
	qemu-utils \
	libvirt-daemon-system \
	libvirt-clients \
	virt-manager \
	virtinst \
	bridge-utils \
	ovmf \
	swtpm

# ================================
# ENABLE LIBVIRT SERVICES
# ================================
log "Enabling libvirt services..."
sudo systemctl enable --now libvirtd

if systemctl list-unit-files virtlogd.socket &>/dev/null; then
	sudo systemctl enable --now virtlogd.socket
fi

# ================================
# USER GROUP SETUP
# ================================
log "Adding current user to libvirt and kvm groups..."
sudo usermod -aG libvirt "$USER"

if getent group kvm &>/dev/null; then
	sudo usermod -aG kvm "$USER"
else
	warn "Group 'kvm' was not found; skipping kvm group membership."
fi

# ================================
# DEFAULT NETWORK SETUP
# ================================
if command -v virsh &>/dev/null; then
	log "Ensuring libvirt default network is active..."
	if sudo virsh net-info default &>/dev/null; then
		sudo virsh net-autostart default || warn "Unable to autostart libvirt default network."
		sudo virsh net-start default &>/dev/null || true
	else
		warn "Libvirt default network was not found; create one manually if VM networking is unavailable."
	fi
fi

# ================================
# VERIFY INSTALLATION
# ================================
command -v qemu-system-x86_64 &>/dev/null || die "qemu-system-x86_64 was not found after installation."
command -v qemu-img &>/dev/null || die "qemu-img was not found after installation."
command -v virsh &>/dev/null || die "virsh was not found after installation."
command -v virt-manager &>/dev/null || die "virt-manager was not found after installation."

success "QEMU and libvirt installed successfully."
warn "Log out and back in for libvirt/kvm group membership to take effect."
