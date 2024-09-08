#!/bin/bash

THEME_DIR="$HOME/.local/share/org.kde.syntax-highlighting/themes"
CHOC_FILES=("$THEME_DIR/Chocula-Pastel.theme" "$THEME_DIR/Chocula.theme")
PROGRAMS=()

printf "Removing katepart theme(s)... "

for k in "kate" "kdevelop" "kile" "kwrite"; do  # Populate array of installed katepart programs
	[[ ! $(command -v "$k") == "" ]] && PROGRAMS+=("$k")
done

for c in "${CHOC_FILES[@]}"; do 	[[ -f $c ]] && rm "$c" ; done # Delete theme(s)

for p in "${PROGRAMS[@]}"; do  # For each program installed,
	config=$HOME/.config/$p"rc"
	default=$(kreadconfig5 --file "$config" --group "KTextEditor Renderer" --key "Color Theme")
	if [[ $default =~ "Chocula" ]]; then  # If default theme is Chocula*, update config file to auto-select theme
		kwriteconfig5 --file "$config" --group "KTextEditor Renderer" --key "Auto Color Theme Selection" "true"
	fi
done

echo "Done."
