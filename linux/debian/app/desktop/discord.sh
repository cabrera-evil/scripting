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

# ================================
# CONFIG
# ================================
URL="https://discord.com/api/download?platform=linux"
TMP_DEB="$(mktemp --suffix=.deb)"

# ================================
# DOWNLOAD
# ================================
log "Downloading latest Discord release..."
wget -O "$TMP_DEB" "$URL"

# ================================
# INSTALL
# ================================
log "Installing Discord..."
sudo apt install -y "$TMP_DEB"

log "Discord installed."

# ================================
# CONFIG UPDATE
# ================================
if prompt_yes_no "Update Discord settings to skip host update?"; then
	log "Updating Discord settings..."
	SETTINGS_PATH="$HOME/.config/discord/settings.json"
	if [[ -f "$SETTINGS_PATH" ]]; then
		command -v jq >/dev/null 2>&1 || die "jq is required to update existing settings.json"
		TMP_SETTINGS="$(mktemp)"
		jq '.SKIP_HOST_UPDATE = true' "$SETTINGS_PATH" >"$TMP_SETTINGS"
		mv "$TMP_SETTINGS" "$SETTINGS_PATH"
	else
		mkdir -p "$(dirname "$SETTINGS_PATH")"
		cat >"$SETTINGS_PATH" <<'EOF'
{
  "SKIP_HOST_UPDATE": true
}
EOF
	fi
	success "Discord settings updated."
else
	log "Skipping Discord settings update."
fi

success "Discord setup complete!"
