#!/usr/bin/env bash
set -euo pipefail

# ===================================
# COLORS
# ===================================
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[1;33m'
BLUE='\e[0;34m'
NC='\e[0m' # No Color

# ===================================
# GLOBAL CONFIGURATION
# ===================================
SILENT=false

# ===================================
# LOGGING
# ===================================
log() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${BLUE}==> $1${NC}"
    fi
}
warn() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${YELLOW}⚠️  $1${NC}" >&2
    fi
}
success() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${GREEN}✓ $1${NC}"
    fi
}
abort() {
    if [ "$SILENT" != "true" ]; then
        echo -e "${RED}✗ $1${NC}" >&2
    fi
    exit 1
}

# ===================================
# CHECKS
# ===================================
for cmd in grep awk sed basename dirname source; do
	command -v "$cmd" >/dev/null || abort "Command '$cmd' is required but not found."
done

# ===================================
# CONFIG
# ===================================
DISTRO_NAME=$(. /etc/os-release && echo "$ID")
DISTRO_PATH="linux/$DISTRO_NAME"
DIR="$(pwd)"

[[ ! -d "$DIR/$DISTRO_PATH" ]] && abort "$DISTRO_NAME is not supported."

# ===================================
# ERROR HANDLERS
# ===================================
trap 'abort "Aborted."' INT
trap 'abort "Last command \"$BASH_COMMAND\" failed with exit code $?."' ERR

# ===================================
# UTILS
# ===================================
title() {
	clear
	log "$1"
	cat <<"EOF"
  __  __       _         __  __                  
 |  \/  | __ _(_)_ __   |  \/  | ___ _ __  _   _ 
 | |\/| |/ _` | | '_ \  | |\/| |/ _ \ '_ \| | | |
 | |  | | (_| | | | | | | |  | |  __/ | | | |_| |
 |_|  |_|\__,_|_|_| |_| |_|  |_|\___|_| |_|\__,_|

EOF
}

install_selected() {
	if [[ "$script_choice" == "0" ]]; then
		echo -e "${BLUE}Nothing to do...${NC}"
		return
	fi

	if [[ "$script_choice" =~ ^[Aa][Ll][Ll]$ ]]; then
		for script in "${script_list[@]}"; do
			source "$script"
		done
		return
	fi

	IFS=',' read -ra selected_indices <<<"$script_choice"

	for index in "${selected_indices[@]}"; do
		if [[ "$index" =~ ^[0-9]+$ ]]; then
			selected_script="${script_list[$((index - 1))]}"
			if [[ -n "$selected_script" && -f "$selected_script" ]]; then
				source "$selected_script"
			else
				handle_not_found 1 "Invalid choice" "Script $index does not exist."
			fi
		elif [[ "$index" =~ ^[0-9]+-[0-9]+$ ]]; then
			IFS='-' read -ra range <<<"$index"
			start=${range[0]}
			end=${range[1]}
			if [[ "$start" -le "$end" ]]; then
				for ((i = start; i <= end; i++)); do
					selected_script="${script_list[$((i - 1))]}"
					if [[ -n "$selected_script" && -f "$selected_script" ]]; then
						source "$selected_script"
					else
						handle_not_found 1 "Invalid range" "Script $i does not exist."
					fi
				done
			else
				handle_not_found 1 "Invalid range" "Start index cannot be greater than end."
			fi
		else
			handle_not_found 1 "Invalid choice" "Please enter valid numbers, range or 'all'."
		fi
	done
}

handle_scripts() {
	local action_type=$1
	local script_subdir=$2
	local script_desc=$3
	local path="$DIR/$DISTRO_PATH/$script_subdir"

	[[ ! -d "$path" ]] && abort "Path not found: $path"

	script_list=("$path"/*.sh)
	((${#script_list[@]} == 0)) && abort "No scripts found in $script_subdir"

	title "Available $script_desc:"
	for i in "${!script_list[@]}"; do
		echo "$((i + 1)). $(basename "${script_list[$i]}" .sh)"
	done

	echo -e "${YELLOW}Select $script_desc to $action_type:${NC}"
	echo -e "${YELLOW}Enter script numbers (e.g. 1,2,4), range (1-3), 'all' or 0 to cancel:${NC}"
	read -rp "==> " script_choice

	install_selected
}

menu() {
	while true; do
		title "Main Menu - $DISTRO_NAME"
		echo "1. Update system"
		echo "2. Install terminal apps"
		echo "3. Install desktop apps"
		echo "4. Install both terminal and desktop"
		echo "5. Run configuration scripts"
		echo "0. Exit"
		read -p "Choose an option: " opt
		case "$opt" in
		1) bash "$DIR/$DISTRO_PATH/config/update.sh" ;;
		2) handle_scripts install "app/terminal" "terminal apps" ;;
		3) handle_scripts install "app/desktop" "desktop apps" ;;
		4)
			handle_scripts install "app/terminal" "terminal apps"
			handle_scripts install "app/desktop" "desktop apps"
			;;
		5) handle_scripts configure "config" "configuration scripts" ;;
		0) break ;;
		*) abort "Invalid option: $opt" ;;
		esac
		read -n1 -rsp $'\nPress any key to continue...\n'
	done
}

main() { menu; }
main
