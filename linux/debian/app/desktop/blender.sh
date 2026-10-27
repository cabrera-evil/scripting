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
	NC=$'\033[0m'
else
	RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' NC=''
fi

# ===================================
# GLOBAL CONFIGURATION
# ===================================
QUIET=false
DEBUG=false

# ===================================
# LOGGING FUNCTIONS
# ===================================
log() { if [[ "$QUIET" != true ]]; then printf '%s▶%s %s\n' "$BLUE" "$NC" "$*"; fi; }
warn() { printf '%s⚠%s %s\n' "$YELLOW" "$NC" "$*" >&2; }
error() { printf '%s✗%s %s\n' "$RED" "$NC" "$*" >&2; }
success() { if [[ "$QUIET" != true ]]; then printf '%s✓%s %s\n' "$GREEN" "$NC" "$*"; fi; }
debug() { if [[ "$DEBUG" == true ]]; then printf '%s⚈%s DEBUG: %s\n' "$MAGENTA" "$NC" "$*" >&2; fi; }
die() {
	error "$*"
	exit 1
}

# ===================================
# CONFIGURATION AND PREREQUISITES
# ===================================
for tool in uname wget grep sort tar xz sha256sum mktemp install ln sudo mv readlink rm; do
	command -v "$tool" >/dev/null 2>&1 || die "Required tool '$tool' is not installed."
done

[[ "$(uname -m)" == "x86_64" ]] || die "Blender installer supports x86_64 only."

BASE_URL="https://download.blender.org/release"
INDEX_URL="${BASE_URL}/"
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# ===================================
# RELEASE DISCOVERY
# ===================================
log "Discovering the latest stable Blender release..."
wget --no-config --no-background -O "$TMP_DIR/index.html" "$INDEX_URL" </dev/null || die "Could not fetch Blender release index."

SERIES=()
while IFS= read -r candidate; do
	[[ "$candidate" =~ ^Blender[0-9]+\.[0-9]+$ ]] || die "Invalid Blender release series in index: $candidate"
	SERIES+=("$candidate")
done < <(grep -Eo 'Blender[0-9]+\.[0-9]+/' "$TMP_DIR/index.html" | grep -Eo 'Blender[0-9]+\.[0-9]+' | sort -Vu)

((${#SERIES[@]} > 0)) || die "No Blender release series found in official index."
SERIES_NAME="${SERIES[${#SERIES[@]}-1]}"
[[ "$SERIES_NAME" =~ ^Blender[0-9]+\.[0-9]+$ ]] || die "Invalid selected release series."

SERIES_URL="${BASE_URL}/${SERIES_NAME}/"
wget --no-config --no-background -O "$TMP_DIR/series.html" "$SERIES_URL" </dev/null || die "Could not fetch release series ${SERIES_NAME}."

ASSETS=()
while IFS= read -r candidate; do
	[[ "$candidate" =~ ^blender-[0-9]+\.[0-9]+\.[0-9]+-linux-x64\.tar\.xz$ ]] || die "Invalid Blender archive asset in index: $candidate"
	ASSETS+=("$candidate")
done < <(grep -Eo 'blender-[0-9]+\.[0-9]+\.[0-9]+-linux-x64\.tar\.xz' "$TMP_DIR/series.html" | sort -Vu)

((${#ASSETS[@]} > 0)) || die "No stable Linux x64 archive found in ${SERIES_NAME}."
ASSET="${ASSETS[${#ASSETS[@]}-1]}"
[[ "$ASSET" =~ ^blender-([0-9]+\.[0-9]+\.[0-9]+)-linux-x64\.tar\.xz$ ]] || die "Invalid selected Blender archive."
VERSION="${BASH_REMATCH[1]}"
ARCHIVE_ROOT="blender-${VERSION}-linux-x64"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "Invalid selected Blender version."

ARCHIVE_URL="${SERIES_URL}${ASSET}"
CHECKSUM_URL="${ARCHIVE_URL}.sha256"
ARCHIVE_PATH="${TMP_DIR}/${ASSET}"
CHECKSUM_PATH="${TMP_DIR}/${ASSET}.sha256"

# ===================================
# DOWNLOAD AND CHECKSUM VERIFICATION
# ===================================
log "Downloading Blender ${VERSION} and its official SHA-256 file..."
wget --no-config --no-background -O "$ARCHIVE_PATH" "$ARCHIVE_URL" </dev/null || die "Could not download Blender archive."
wget --no-config --no-background -O "$CHECKSUM_PATH" "$CHECKSUM_URL" </dev/null || die "Could not download Blender SHA-256 file."

CHECKSUM_LINES=()
while IFS= read -r line; do
	[[ "$line" =~ ^([[:xdigit:]]{64})([[:space:]]+([^[:space:]]+))?$ ]] || die "Malformed SHA-256 file for ${ASSET}."
	[[ -z "${BASH_REMATCH[3]:-}" || "${BASH_REMATCH[3]}" == "$ASSET" ]] || die "SHA-256 file names a different archive."
	CHECKSUM_LINES+=("${BASH_REMATCH[1],,}")
done < "$CHECKSUM_PATH"
((${#CHECKSUM_LINES[@]} == 1)) || die "SHA-256 file must contain exactly one matching digest."
EXPECTED_SHA="${CHECKSUM_LINES[0]}"
ACTUAL_SHA="$(sha256sum "$ARCHIVE_PATH")"
ACTUAL_SHA="${ACTUAL_SHA%% *}"
[[ "$ACTUAL_SHA" == "$EXPECTED_SHA" ]] || die "Blender archive SHA-256 verification failed."

# ===================================
# ARCHIVE VALIDATION AND EXTRACTION
# ===================================
log "Validating Blender distribution archive..."
tar -tJf "$ARCHIVE_PATH" > "$TMP_DIR/archive.list" || die "Blender archive is malformed."
FOUND_BINARY=false
while IFS= read -r entry; do
	[[ "$entry" == "$ARCHIVE_ROOT" || "$entry" == "$ARCHIVE_ROOT/"* ]] || die "Unexpected archive path: $entry"
	[[ "$entry" != /* && "/$entry/" != *"/../"* && "$entry" != */.. ]] || die "Unsafe archive path: $entry"
	[[ "$entry" == "$ARCHIVE_ROOT/blender" ]] && FOUND_BINARY=true
done < "$TMP_DIR/archive.list"
[[ "$FOUND_BINARY" == true ]] || die "Archive does not contain the expected Blender executable."

tar -xJf "$ARCHIVE_PATH" -C "$TMP_DIR" || die "Could not extract Blender archive."
[[ -x "$TMP_DIR/$ARCHIVE_ROOT/blender" ]] || die "Extracted Blender executable is missing or not executable."

# ===================================
# INSTALLATION
# ===================================
INSTALL_DIR="/opt/blender-${VERSION}"
LINK_PATH="/usr/local/bin/blender"
if [[ "$(readlink -f "$LINK_PATH" 2>/dev/null || true)" == "${INSTALL_DIR}/blender" ]]; then
	success "Blender ${VERSION} is already current; leaving it unchanged."
	exit 0
fi

if [[ ! -x "${INSTALL_DIR}/blender" ]]; then
	STAGING_DIR="/opt/.blender-${VERSION}.staging.$$"
	BACKUP_DIR="/opt/.blender-${VERSION}.backup.$$"
	sudo install -d "$STAGING_DIR" || die "Could not create Blender staging directory."
	if ! sudo tar -xJf "$ARCHIVE_PATH" -C "$STAGING_DIR" --strip-components=1; then
		sudo rm -rf "$STAGING_DIR"
		die "Could not stage Blender distribution under /opt."
	fi
	[[ -x "$STAGING_DIR/blender" ]] || { sudo rm -rf "$STAGING_DIR"; die "Staged Blender executable is missing."; }
	if [[ -e "$INSTALL_DIR" ]]; then
		sudo mv "$INSTALL_DIR" "$BACKUP_DIR" || die "Could not preserve the previous Blender directory."
	fi
	if ! sudo mv "$STAGING_DIR" "$INSTALL_DIR"; then
		[[ ! -e "$BACKUP_DIR" ]] || sudo mv "$BACKUP_DIR" "$INSTALL_DIR"
		die "Could not activate staged Blender distribution."
	fi
	[[ ! -e "$BACKUP_DIR" ]] || sudo rm -rf "$BACKUP_DIR"
fi

[[ -x "${INSTALL_DIR}/blender" ]] || die "Installed Blender executable is missing."
LINK_TMP="/usr/local/bin/.blender-link.$$"
sudo ln -s "${INSTALL_DIR}/blender" "$LINK_TMP" || die "Could not create Blender command symlink."
if ! sudo mv -Tf "$LINK_TMP" "$LINK_PATH"; then
	sudo rm -f "$LINK_TMP"
	die "Could not atomically update Blender command symlink."
fi

success "Blender ${VERSION} installed successfully."
