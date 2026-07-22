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
TARGET_USER="${SUDO_USER:-${USER}}"

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
# PRE-FLIGHT CHECKS
# ================================
command -v apt >/dev/null 2>&1 || die "This installer requires apt."
getent passwd "$TARGET_USER" >/dev/null || die "User '$TARGET_USER' does not exist."

log "Requesting administrator access..."
sudo -v

# ================================
# KVM ACCELERATION
# ================================
enable_kvm_acceleration() {
	local kvm_module=''
	local modules_file='/etc/modules-load.d/qemu-kvm.conf'

	if [[ -e /dev/kvm ]]; then
		success "KVM acceleration is available."
		return
	fi

	case "$(uname -m)" in
		x86_64 | i?86)
			if grep -qw vmx /proc/cpuinfo; then
				kvm_module='kvm_intel'
			elif grep -qw svm /proc/cpuinfo; then
				kvm_module='kvm_amd'
			fi
			;;
		aarch64 | arm64) kvm_module='kvm' ;;
		*)
			warn "Automatic KVM module loading is not configured for $(uname -m)."
			return
			;;
	esac

	if [[ -z "$kvm_module" ]]; then
		warn "The CPU does not report hardware virtualization support; QEMU will use software emulation."
		return
	fi

	log "Loading the $kvm_module kernel module..."
	if ! sudo modprobe "$kvm_module"; then
		warn "Could not load $kvm_module. Enable virtualization (VT-x/AMD-V/SVM) in BIOS/UEFI, then reboot."
		return
	fi

	if [[ -e /dev/kvm ]]; then
		if ! sudo grep -Fqx "$kvm_module" "$modules_file" 2>/dev/null; then
			printf '%s\n' "$kvm_module" | sudo tee -a "$modules_file" >/dev/null
		fi
		success "KVM acceleration is enabled and will load automatically on boot."
	else
		warn "$kvm_module loaded but /dev/kvm is still unavailable. Enable virtualization in BIOS/UEFI, then reboot."
	fi
}

enable_kvm_acceleration

# ================================
# INSTALL QEMU AND LIBVIRT
# ================================
log "Updating package list..."
sudo apt update

log "Installing the QEMU, libvirt, UEFI, TPM, networking, and VM management stack..."
# OVMF provides x86_64 UEFI firmware on Debian; qemu-efi-aarch64 adds ARM64 UEFI firmware.
sudo apt install -y \
	qemu-system \
	qemu-system-gui \
	qemu-block-extra \
	qemu-utils \
	qemu-efi-aarch64 \
	libvirt-daemon-system \
	libvirt-clients \
	libvirt-daemon-driver-qemu \
	virt-manager \
	virtinst \
	virt-viewer \
	libosinfo-bin \
	bridge-utils \
	dnsmasq-base \
	ovmf \
	swtpm \
	swtpm-tools \
	spice-client-gtk \
	cloud-image-utils \
	genisoimage \
	libguestfs-tools

# ================================
# ENABLE LIBVIRT SERVICES
# ================================
enable_unit_if_available() {
	local unit="$1"

	if systemctl list-unit-files --no-legend "$unit" 2>/dev/null | awk -v unit="$unit" '$1 == unit { found = 1 } END { exit !found }'; then
		log "Enabling $unit..."
		sudo systemctl enable --now "$unit"
		return
	fi

	debug "Systemd unit '$unit' is not installed."
}

log "Enabling libvirt services..."
# Debian 12+ normally uses modular, socket-activated daemons; older releases use libvirtd.
enable_unit_if_available virtqemud.socket
enable_unit_if_available virtnetworkd.socket
enable_unit_if_available virtstoraged.socket
enable_unit_if_available virtlogd.socket
enable_unit_if_available libvirtd.service

# ================================
# USER GROUP SETUP
# ================================
log "Granting $TARGET_USER access to system virtual machines..."
for group in libvirt kvm; do
	if getent group "$group" >/dev/null; then
		if id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx "$group"; then
			debug "$TARGET_USER is already in the $group group."
		else
			sudo usermod -aG "$group" "$TARGET_USER"
			success "Added $TARGET_USER to the $group group."
		fi
	else
		warn "Group '$group' was not found; skipping group membership."
	fi
done

# ================================
# DEFAULT NETWORK SETUP
# ================================
log "Ensuring the libvirt default network starts automatically..."
if sudo virsh -c qemu:///system net-info default >/dev/null 2>&1; then
	sudo virsh -c qemu:///system net-autostart default || warn "Unable to autostart the default libvirt network."
	if ! sudo virsh -c qemu:///system net-is-active default >/dev/null; then
		sudo virsh -c qemu:///system net-start default || warn "Unable to start the default libvirt network."
	fi
else
	warn "The libvirt default network was not found; create one manually if VM networking is unavailable."
fi

# ================================
# VERIFY INSTALLATION
# ================================
command -v qemu-img >/dev/null 2>&1 || die "qemu-img was not found after installation."
command -v virsh >/dev/null 2>&1 || die "virsh was not found after installation."
command -v virt-install >/dev/null 2>&1 || die "virt-install was not found after installation."
command -v virt-manager >/dev/null 2>&1 || die "virt-manager was not found after installation."
command -v osinfo-query >/dev/null 2>&1 || die "osinfo-query was not found after installation."

if sudo virsh -c qemu:///system uri >/dev/null 2>&1; then
	success "QEMU, libvirt, and VM tooling are ready."
else
	warn "Packages are installed, but libvirt is not yet responding. Check: sudo systemctl status virtqemud.socket libvirtd.service"
fi

warn "Log out and back in (or run 'newgrp libvirt') before using libvirt without sudo."
log "Useful commands: virt-manager, virt-install --osinfo list, osinfo-query os, qemu-img create -f qcow2 disk.qcow2 40G"
