#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
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

# ===================================
# GLOBAL CONFIGURATION
# ===================================
QUIET=false
DEBUG=false

# ===================================
# LOGGING FUNCTIONS
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

# ===================================
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

GRUB_FILE="/etc/default/grub"
GRUB_BACKUP="/etc/default/grub.bak"
THEMES_DIR="/usr/share/grub/themes"

# ===================================
# BACKUP ORIGINAL GRUB CONFIG
# ===================================
log "Backing up GRUB configuration to $GRUB_BACKUP..."
sudo cp "$GRUB_FILE" "$GRUB_BACKUP"

# ===================================
# SET GRUB_DEFAULT=SAVED
# ===================================
log "Setting GRUB_DEFAULT to 'saved'..."
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' "$GRUB_FILE"

# ===================================
# ENSURE GRUB_SAVEDEFAULT=TRUE IS PRESENT
# ===================================
if grep -q '^GRUB_SAVEDEFAULT=true' "$GRUB_FILE"; then
	warn "GRUB_SAVEDEFAULT already present. Skipping..."
else
	log "Adding GRUB_SAVEDEFAULT=true..."
	sudo sed -i '/^GRUB_DEFAULT=.*/a GRUB_SAVEDEFAULT=true' "$GRUB_FILE"
fi

# ===================================
# SET GRUB_TIMEOUT=5
# ===================================
log "Setting GRUB_TIMEOUT to 5 seconds..."
if grep -q '^GRUB_TIMEOUT=' "$GRUB_FILE"; then
	sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=5/' "$GRUB_FILE"
else
	echo 'GRUB_TIMEOUT=5' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# ENSURE GRUB_DISABLE_OS_PROBER=FALSE
# ===================================
log "Ensuring GRUB_DISABLE_OS_PROBER=false..."
if grep -q '^#*GRUB_DISABLE_OS_PROBER=' "$GRUB_FILE"; then
	sudo sed -i 's/^#*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' "$GRUB_FILE"
else
	echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a "$GRUB_FILE" >/dev/null
fi

# ===================================
# ASK ABOUT CATPPUCCIN GRUB THEME INSTALLATION
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
# APPLY GRUB CONFIGURATION
# ===================================
log "Updating GRUB..."
sudo update-grub
success "GRUB configuration updated successfully!"

# ===================================
# ASK ABOUT REBOOT
# ===================================
if prompt_yes_no "Do you want to reboot now to see the changes?"; then
	log "Rebooting system..."
	sudo reboot
else
	success "Configuration complete! Reboot when you're ready to see the changes."
fi
