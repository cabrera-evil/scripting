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
# PACKAGES TO INSTALL
# ================================
packages=(
	bat             # cat alternative with syntax highlighting
	curl            # data transfer tool
	git             # version control
	git-flow        # branching model support
	htop            # interactive process viewer
	lsd             # modern ls with icons
	ncdu            # disk usage analyzer
	ranger          # terminal file manager
	rsync           # fast file synchronization
	tmux            # terminal multiplexer
	trash-cli       # safe file deletion
	unzip           # unzip .zip files
	unrar           # unrar .rar files
	wget            # network downloader
	xclip           # clipboard integration
	zip             # zip compression
	zsh             # powerful shell
	build-essential # gcc, g++, make
	libssl-dev      # SSL dev headers (required for many Node/Python packages)
	resolvconf      # DNS resolution management
	wireguard       # VPN protocol
	net-tools       # ifconfig/netstat (legacy, still useful)
	bluez           # Bluetooth stack
	filezilla       # FTP/SFTP client
	fzf             # fuzzy finder for terminal
	ripgrep         # fast grep alternative
	jq              # JSON processor
	tree            # recursive directory listing
	gnupg           # for GPG key management
	openssh-client  # SSH utilities
	ca-certificates # SSL certs bundle
	whois           # whois query tool
	vim             # text editor
)

# ================================
# UPDATE AND INSTALL
# ================================
log "Updating package lists..."
sudo apt update -y

log "Installing selected packages..."
sudo apt install -y "${packages[@]}"

success "All packages installed successfully!"
