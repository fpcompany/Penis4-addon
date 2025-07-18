#!/bin/sh

TARGET_DIR="/home/benis/.local/share/Steam/steamapps/compatdata/3318515424/pfx/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/Penis4"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Recursively find all files and copy them to the target directory, preserving structure
find . -type f | while read -r FILE; do
    REL_PATH="${FILE#./}"  # Remove the leading './'
    DEST_PATH="$TARGET_DIR/$REL_PATH"
    mkdir -p "$(dirname "$DEST_PATH")"
    cp -f "$FILE" "$DEST_PATH"
done

echo "All files copied to $TARGET_DIR."
