
#!/bin/bash

# File to preview
FILE="$1"

# Check if file exists
if [[ ! -f "$FILE" ]]; then
  echo "Usage: $0 <file-to-preview>"
  exit 1
fi

# List of Catppuccin themes
THEMES=("Catppuccin Latte" "Catppuccin Frappe" "Catppuccin Macchiato" "Catppuccin Mocha")

# Loop through themes and show file
for THEME in "${THEMES[@]}"; do
  echo
  echo "=============================="
  echo " Theme: $THEME"
  echo "=============================="
  bat --theme="$THEME" "$FILE"
  echo
  read -n 1 -s -r -p "Press any key to continue to the next theme..."
done
