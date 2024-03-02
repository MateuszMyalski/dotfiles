#!/bin/bash

destination_dir=".config"
copy_files=false  # Flag for actual copying

# List of files to copy
files=(
    "$HOME/.config/gtk-3.0/gtk.css"
    "$HOME/.config/xfce4/gtk-3.0/gtk.css"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/displays.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml.bak"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-settings-manager.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-appfinder.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-mime-settings.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-settings-editor.xml"
    "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
    "$HOME/.config/rofi/config.rasi"
    "$HOME/.config/rofi/tokyonight.rasi"
)

# Function to display usage information
usage() {
    echo "Usage: $0 [-c]"
    echo "Options:"
    echo "  -c    Perform actual copying (default is dry run)"
    exit 1
}

# Parse command-line options
while getopts ":c" opt; do
    case ${opt} in
        c )
            copy_files=true
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Iterate through each file in the list
for file in "${files[@]}"; do
    if [ -e "$file" ]; then
        relative_path="${file#*.config/}"
        dest_path="$destination_dir/$(dirname "$relative_path")"
        if $copy_files ; then
            mkdir -p "$dest_path"  # Create directory if it doesn't exist
            cp "$file" "$dest_path"
            echo "Copied $file to $dest_path."
        else
            echo "Dry run: Would copy $file to $dest_path."
        fi
    else
        echo "File $file does not exist."
    fi
done
