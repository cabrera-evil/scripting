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
# SCRIPT CONFIGURATION
# ================================
PGDG_SCRIPT="/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh"
PG_REPO_SOURCES="/etc/apt/sources.list.d/pgdg.sources"
PG_REPO_LIST="/etc/apt/sources.list.d/pgdg.list"
POSTGRES_PACKAGES=(postgresql-common postgresql-client)

# ================================
# PREREQUISITES
# ================================
log "Updating package lists..."
sudo apt update -y

log "Installing PostgreSQL common utilities (provides PGDG bootstrap)..."
sudo apt install -y postgresql-common

[[ -x "$PGDG_SCRIPT" ]] || die "PGDG bootstrap script not found at ${PGDG_SCRIPT}"

# ================================
# CONFIGURE REPOSITORY
# ================================
if [[ -f "$PG_REPO_SOURCES" ]] || grep -qs "apt.postgresql.org" "$PG_REPO_LIST" 2>/dev/null; then
	log "PostgreSQL APT repository already configured; skipping bootstrap."
else
	log "Adding PostgreSQL APT repository via ${PGDG_SCRIPT}..."
	sudo "$PGDG_SCRIPT"
fi

log "Refreshing package lists after repository setup..."
sudo apt update -y

# ================================
# INSTALL CLIENT TOOLS
# ================================
log "Installing PostgreSQL client components..."
sudo apt install -y "${POSTGRES_PACKAGES[@]}"

success "PostgreSQL client ready. Verify with: psql --version"
