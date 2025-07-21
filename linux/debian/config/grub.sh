#!/usr/bin/env bash
set -euo pipefail

# ===================================
# Colors
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# Logging
# ===================================
log() { echo -e "${BLUE}==> $1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}! $1${NC}"; }
abort() {
	echo -e "${RED}✗ $1${NC}" >&2
	exit 1
}

# ===================================
# User input function
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

# ===================================
# Checks
# ===================================
for cmd in sudo cp sed grep update-grub git; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

GRUB_FILE="/etc/default/grub"
GRUB_BACKUP="/etc/default/grub.bak"
THEMES_DIR="/usr/share/grub/themes"

# ===================================
# Backup original GRUB config
# ===================================
log "Backing up GRUB configuration to $GRUB_BACKUP..."
sudo cp "$GRUB_FILE" "$GRUB_BACKUP"

# ===================================
# Set GRUB_DEFAULT=saved
# ===================================
log "Setting GRUB_DEFAULT to 'saved'..."
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE"

# ===================================
# Ensure GRUB_SAVEDEFAULT=true is present
# ===================================
if grep -q '^GRUB_SAVEDEFAULT=true' "$GRUB_FILE"; then
	warn "GRUB_SAVEDEFAULT already present. Skipping..."
else
	log "Adding GRUB_SAVEDEFAULT=true..."
	sudo sed -i '/^GRUB_DEFAULT=.*/a GRUB_SAVEDEFAULT=true' "$GRUB_FILE"
fi

# ===================================
# Set GRUB_TIMEOUT=5
# ===================================
log "Setting GRUB_TIMEOUT to 5 seconds..."
if grep -q '^GRUB_TIMEOUT=' "$GRUB_FILE"; then
	sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' "$GRUB_FILE"
else
	echo 'GRUB_TIMEOUT=5' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# Ensure GRUB_DISABLE_OS_PROBER=false
# ===================================
log "Ensuring GRUB_DISABLE_OS_PROBER=false..."
if grep -q '^#*GRUB_DISABLE_OS_PROBER=' "$GRUB_FILE"; then
	sudo sed -i 's/^#*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE"
else
	echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# Ask about Catppuccin GRUB theme installation
# ===================================
if prompt_yes_no "Do you want to install the Catppuccin GRUB theme?"; then
	log "Installing Catppuccin GRUB theme..."

	# Create temporary directory for theme installation
	TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR"

	# Clone the repository
	log "Cloning Catppuccin GRUB theme repository..."
	git clone https://github.com/catppuccin/grub.git
	cd grub

	# Create themes directory if it doesn't exist
	sudo mkdir -p "$THEMES_DIR"

	# Copy themes to system directory
	log "Copying themes to $THEMES_DIR..."
	sudo cp -r src/* "$THEMES_DIR/"

	# List available themes
	echo -e "${BLUE}Available Catppuccin themes:${NC}"
	ls "$THEMES_DIR" | grep "catppuccin-.*-grub-theme" | sed 's/catppuccin-\(.*\)-grub-theme/  - \1/'

	# Ask user to select a theme
	echo -e "${YELLOW}Enter the flavor you want to use (e.g., mocha, latte, frappe, macchiato): ${NC}"
	read -r theme_flavor

	THEME_PATH="$THEMES_DIR/catppuccin-$theme_flavor-grub-theme/theme.txt"

	# Check if the selected theme exists
	if [[ -f "$THEME_PATH" ]]; then
		log "Setting GRUB theme to catppuccin-$theme_flavor..."

		# Remove existing GRUB_THEME line if present
		sudo sed -i '/^#*GRUB_THEME=/d' "$GRUB_FILE"

		# Add new GRUB_THEME line
		echo "GRUB_THEME=\"$THEME_PATH\"" | sudo tee -a "$GRUB_FILE" >/dev/null

		success "Catppuccin theme ($theme_flavor) configured successfully!"
	else
		warn "Theme '$theme_flavor' not found. Skipping theme configuration."
	fi

	# Clean up temporary directory
	cd /
	rm -rf "$TEMP_DIR"
else
	log "Skipping Catppuccin GRUB theme installation..."
fi

# ===================================
# Apply GRUB configuration
# ===================================
log "Updating GRUB..."
sudo update-grub
success "GRUB configuration updated successfully!"

# ===================================
# Ask about reboot
# ===================================
if prompt_yes_no "Do you want to reboot now to see the changes?"; then
	log "Rebooting system..."
	sudo reboot
else
	success "Configuration complete! Reboot when you're ready to see the changes."
fi
