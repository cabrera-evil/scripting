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
SILENT=${SILENT:-false}
GRUB_CONFIG="/etc/default/grub"
GRUB_BACKUP="${GRUB_CONFIG}.backup"
NM_CONF_DIR="/etc/NetworkManager/conf.d"
NM_DISPATCHER_DIR="/etc/NetworkManager/dispatcher.d"

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
# UTILITY FUNCTIONS
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

create_nm_config() {
	local filename="$1"
	local content="$2"
	sudo tee "$NM_CONF_DIR/$filename" >/dev/null <<<"$content"
}

# ================================
# VALIDATION
# ================================
validate_environment() {
	[[ $EUID -eq 0 ]] && die "Do not run as root. Script will use sudo when needed."
	log "Environment validation completed"
}

# ================================
# SYSTEM PREPARATION
# ================================
update_system() {
	log "Updating package repositories..."
	sudo apt update
}

install_drivers() {
	log "Installing network interface drivers..."
	sudo apt install -y firmware-realtek -t bookworm-backports
	success "Network interface drivers installation completed"
}

# ================================
# POWER MANAGEMENT CONFIGURATION
# ================================
configure_grub() {
	log "Configuring GRUB to disable PCIe power management permanently..."

	# Backup original GRUB configuration
	if [[ ! -f "$GRUB_BACKUP" ]]; then
		sudo cp "$GRUB_CONFIG" "$GRUB_BACKUP"
		log "Created backup of GRUB configuration"
	fi

	# Add pcie_aspm=off if not present
	if ! grep -q "pcie_aspm=off" "$GRUB_CONFIG"; then
		log "Adding pcie_aspm=off to GRUB configuration..."
		sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\([^"]*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 pcie_aspm=off"/' "$GRUB_CONFIG"

		log "Updating GRUB configuration..."
		sudo update-grub
		success "GRUB configuration updated to disable PCIe power management"
	else
		log "PCIe power management already disabled in GRUB configuration"
	fi
}

disable_interface_power_management() {
	log "Disabling power management for wireless interfaces..."

	local interfaces
	interfaces=$(iw dev 2>/dev/null | grep Interface | awk '{print $2}' || true)

	if [[ -z "$interfaces" ]]; then
		warn "No wireless interfaces found"
		return
	fi

	for interface in $interfaces; do
		if iw dev "$interface" get power_save 2>/dev/null | grep -q "Power save: on"; then
			log "Disabling power management for interface: $interface"
			sudo iw dev "$interface" set power_save off
			success "Power management disabled for $interface"
		else
			log "Power management already disabled for $interface"
		fi
	done
}

# ================================
# NETWORKMANAGER CONFIGURATION
# ================================
configure_networkmanager() {
	log "Configuring NetworkManager..."

	# Create configuration directory
	sudo mkdir -p "$NM_CONF_DIR" "$NM_DISPATCHER_DIR"

	# WiFi power save configuration
	create_nm_config "wifi-scan.conf" "[connection]
wifi.powersave=2"

	# WiFi/Ethernet priority configuration
	create_nm_config "wifi-ethernet-priority.conf" "[main]
# Automatically disable WiFi when ethernet is connected
no-auto-default=*

[connectivity]
# Prefer ethernet over WiFi
uri=http://connectivity-check.ubuntu.com/
interval=300

[device]
# Manage all devices
managed=true

[connection]
# Automatically connect to ethernet when available
autoconnect-priority=100"

	# Create dispatcher script for WiFi/Ethernet switching
	sudo tee "$NM_DISPATCHER_DIR/10-wifi-ethernet-switch" >/dev/null <<'EOF'
#!/bin/bash

# NetworkManager dispatcher script to disable WiFi when ethernet is connected
# and re-enable when ethernet is disconnected

interface=$1
action=$2

case "$action" in
    up)
        # If ethernet interface comes up, disable WiFi
        if [[ "$interface" == eth* ]] || [[ "$interface" == enp* ]] || [[ "$interface" == eno* ]]; then
            logger "NetworkManager: Ethernet interface $interface is up, disabling WiFi"
            nmcli radio wifi off
        fi
        ;;
    down)
        # If ethernet interface goes down, enable WiFi
        if [[ "$interface" == eth* ]] || [[ "$interface" == enp* ]] || [[ "$interface" == eno* ]]; then
            # Check if any other ethernet interfaces are still up
            if ! nmcli device status | grep -E '^(eth|enp|eno)' | grep -q connected; then
                logger "NetworkManager: No ethernet interfaces connected, enabling WiFi"
                nmcli radio wifi on
            fi
        fi
        ;;
esac
EOF

	# Make dispatcher script executable
	sudo chmod +x "$NM_DISPATCHER_DIR/10-wifi-ethernet-switch"
	success "NetworkManager configuration completed"
}

# ================================
# MAIN EXECUTION
# ================================
main() {
	validate_environment
	update_system
	install_drivers
	configure_grub
	configure_networkmanager
	disable_interface_power_management

	# Reboot handling
	warn "System reboot required to activate all changes"
	if prompt_yes_no "Reboot now?"; then
		log "Rebooting..."
		sleep 1
		sudo reboot
	else
		warn "Reboot manually with: sudo reboot"
		exit 0
	fi
}

# Execute main function
main "$@"
