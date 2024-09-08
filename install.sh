#!/bin/bash

THEME_DIR="$HOME/.local/share/org.kde.syntax-highlighting/themes"
FLAVORS=("Chocula" "Chocula-Pastel")
PROGRAMS=()

##############################	Function definitions:
populate_programs(){
	for k in "kate" "kdevelop" "kile" "kwrite"; do
		[[ ! $(command -v "$k") == "" ]] && PROGRAMS+=("$k")
	done
}

install_theme(){
	local flavor="${FLAVORS[$1]}"
	printf "Installing %s ... " "$flavor"
	mkdir -p "$THEME_DIR"
	cp "$flavor.theme" "$THEME_DIR"
	echo "Done"
}

set_as_default(){
	local default="$1"	# Selected flavor

	if [[ "$default" == "2" ]];	then
		# Clarify which of the two installed themes to set as default:
		printf "Which variant?\n1) Chocula\n2) Chocula-Pastel\n"
		read -r -p "Enter your selection [1|2]: " default
		((default--))
		[[ "$default" != [0-1] ]] && echo "Invalid selection; exiting" && exit
	fi

	default="${FLAVORS[$default]}"

	# For each program installed, update its config file to use theme as default:
	for p in "${PROGRAMS[@]}"; do
		local config=$HOME/.config/$p"rc"
		touch "$config"
		kwriteconfig5 --file "$config" --group "KTextEditor Renderer" --key "Auto Color Theme Selection" "false"
		kwriteconfig5 --file "$config" --group "KTextEditor Renderer" --key "Color Theme" "$default"
	done

	echo "$default set as default theme for installed katepart applications."
}

##############################	Main logic:
populate_programs
[[ -z "$PROGRAMS" ]] && echo "No katepart applications found. Exiting" && exit

printf "Available flavors to install:\n1) Chocula\n2) Chocula-Pastel\n3) Both\n"
read -r -p "Enter your selection [1|2|3]: " SELECTION
((SELECTION--))	# Decrement selection to match its FLAVORS array index

case $SELECTION in
	0 | 1)	 install_theme "$SELECTION" ;;
	2)	install_theme '0' && install_theme '1' ;;
	*)	echo "Invalid selection; exiting" && exit
esac

read -r -p "Set as default theme? [y|N] " YN
[[ "$YN" == [yY]* ]] && set_as_default "$SELECTION"
