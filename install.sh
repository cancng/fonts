#!/bin/bash

# Set the path to the folder containing the font zip files
FONT_FOLDER=.

# Loop through each zip file in the font folder
mkdir -p /tmp/fonts
for font_zip in "$FONT_FOLDER"/*.zip
do
    file_name_without_extension="${font_zip##*/}"
    file_name_without_extension="${file_name_without_extension%.*}"
    # Extract the zip file to a temporary directory
    unzip -o -q "$font_zip" -d "/tmp/fonts/$file_name_without_extension"
done

# Find all font files in the specified folder and its subfolders
FONT_FILES=$(find "/tmp/fonts" -type f \( -iname \*.ttf -o -iname \*.otf \) )

for font_file in $FONT_FILES
do
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # Move the font file to the system fonts directory
      sudo mv "$font_file" "/Library/Fonts/$(basename "$font_file")"
      # Set the correct file permissions for the font
      sudo chmod 644 "/Library/Fonts/$(basename "$font_file")"
      # Register the font with Font Book using atsutil
      sudo atsutil fontregistration -add "$font_file"
    else
      # Move the font file to the system fonts directory
      sudo mv "$font_file" "/usr/share/fonts/truetype/$(basename "$font_file")"
      # Set the correct file permissions for the font
      sudo chmod 644 "/usr/share/fonts/truetype/$(basename "$font_file")"
    fi
done

# rm -rf /tmp/fonts
# Update the font cache
if [[ "$OSTYPE" == "darwin"* ]]; then
  sudo atsutil databases -removeUser
else
  sudo fc-cache -f -v
fi

echo "Fonts installed successfully!"
