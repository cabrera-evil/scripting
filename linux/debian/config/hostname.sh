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
fi

# ================================
# GLOBAL CONFIGURATION
# ================================
QUIET=false
DEBUG=false

# ================================
# LOGGING FUNCTIONS
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
# PROMPT NEW HOSTNAME
# ================================
read -rp "New hostname (e.g. debian-02): " NEW_HOSTNAME

[[ -z "$NEW_HOSTNAME" ]] && die "Hostname cannot be empty."

if [[ ! "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9]$ ]]; then
	die "Invalid hostname: $NEW_HOSTNAME"
fi

OLD_HOSTNAME="$(hostname)"

# ================================
# SET HOSTNAME
# ================================
log "Changing hostname: ${OLD_HOSTNAME} -> ${NEW_HOSTNAME}"
sudo hostnamectl set-hostname "$NEW_HOSTNAME"

# ================================
# UPDATE /etc/hosts
# ================================
if [[ -f /etc/hosts ]]; then
	log "Backing up /etc/hosts..."
	sudo cp /etc/hosts "/etc/hosts.bak.$(date +%Y%m%d%H%M%S)"

	if grep -qE "^127\.0\.1\.1[[:space:]]+" /etc/hosts; then
		log "Updating existing 127.0.1.1 entry..."
		sudo sed -i -E "s/^127\.0\.1\.1[[:space:]].*/127.0.1.1\t${NEW_HOSTNAME}/" /etc/hosts
	else
		log "Adding 127.0.1.1 entry..."
		printf '127.0.1.1\t%s\n' "$NEW_HOSTNAME" | sudo tee -a /etc/hosts >/dev/null
	fi
fi

# ================================
# REGENERATE MACHINE ID
# ================================
log "Regenerating machine ID..."
sudo rm -f /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id

sudo systemd-machine-id-setup

sudo mkdir -p /var/lib/dbus
sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id

# ================================
# REGENERATE SSH HOST KEYS
# ================================
if command -v ssh-keygen >/dev/null 2>&1; then
	log "Regenerating SSH host keys..."
	sudo rm -f /etc/ssh/ssh_host_*
	sudo ssh-keygen -A

	if systemctl list-unit-files ssh.service &>/dev/null; then
		sudo systemctl restart ssh
	elif systemctl list-unit-files sshd.service &>/dev/null; then
		sudo systemctl restart sshd
	fi
fi

# ================================
# SUMMARY
# ================================
success "Hostname and machine identity updated successfully!"
log "Hostname:   $(hostname)"
log "Machine ID: $(cat /etc/machine-id)"
warn "Make sure any cloned VM also has a unique MAC address."

# ================================
# REBOOT PROMPT
# ================================
read -rp "Reboot now? [y/N]: " REBOOT
case "${REBOOT:-N}" in
[Yy] | [Yy][Ee][Ss])
	sudo reboot
	;;
*)
	log "Reboot manually when ready: sudo reboot"
	;;
esac
