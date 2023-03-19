#!/bin/bash

# Set the path to the folder containing the font zip files
FONT_FOLDER=.

# Loop through each zip file in the font folder
for font_zip in "$FONT_FOLDER"/*.zip
do
    # Extract the zip file to a temporary directory
    unzip -q "$font_zip" -d /tmp/fonts

    # Move the extracted fonts to the system fonts directory
    sudo mv /tmp/fonts/*.ttf /usr/share/fonts/truetype/

    # Set the correct file permissions for the fonts
    sudo chmod 644 /usr/share/fonts/truetype/*.ttf

    # Clean up the temporary directory
    rm -rf /tmp/fonts
done

# Update the font cache
sudo fc-cache -f -v

echo "Fonts installed successfully!"
