#!/bin/bash

# Set the path to the folder containing the font zip files
FONT_FOLDER=.

# Loop through each zip file in the font folder
mkdir /tmp/fonts
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
    # Move the font file to the system fonts directory
    sudo mv "$font_file" /usr/share/fonts/truetype/"$(basename "$font_file")"

    # Set the correct file permissions for the font
    sudo chmod 644 /usr/share/fonts/truetype/"$(basename "$font_file")"
done

# rm -rf /tmp/fonts
# Update the font cache
sudo fc-cache -f -v

echo "Fonts installed successfully!"
