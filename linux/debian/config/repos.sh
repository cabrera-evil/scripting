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
# DETECT CODENAME
# ================================
CODENAME=$(lsb_release -sc 2>/dev/null)
[[ -z "$CODENAME" || "$CODENAME" == "unknown" ]] && die "Could not detect Debian codename."

log "Detected Debian codename: ${BOLD}${CODENAME}${NC}"

# ================================
# COMMENT OUT CURRENT ENTRIES
# ================================
log "Commenting out existing 'deb' entries in /etc/apt/sources.list..."
sudo sed -i 's/^\s*deb /# deb /g' /etc/apt/sources.list

# ================================
# ADD NEW SOURCES
# ================================
log "Adding Debian ${CODENAME} repository entries..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb http://deb.debian.org/debian/ ${CODENAME} contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ ${CODENAME} contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ ${CODENAME}-updates contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ ${CODENAME}-updates contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ ${CODENAME}-proposed-updates contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ ${CODENAME}-proposed-updates contrib main non-free non-free-firmware

deb http://deb.debian.org/debian/ ${CODENAME}-backports contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian/ ${CODENAME}-backports contrib main non-free non-free-firmware

deb http://deb.debian.org/debian-security/ ${CODENAME}-security contrib main non-free non-free-firmware
# deb-src http://deb.debian.org/debian-security/ ${CODENAME}-security contrib main non-free non-free-firmware
EOF

success "Debian ${CODENAME} repositories updated successfully!"
