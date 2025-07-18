#!/bin/bash

# Display help
if [ -n "$1" ]; then
    if [ "$1" = "-h" ] || [  "$1" = "--help" ]; then
        echo "$0.sh [-h|--help] [-d|--dots-only]"
        echo "Help:"
        echo "  -h, --help          Display this help message."
        echo "  -d, --dots-only     Install only the dotfiles without asking for applications."

        exit 0
    fi
fi

read -rp "This script will install dotfiles. Do you want to proceed? (yes/no): " answer

if [ "$answer" != "yes" ]; then
    echo "Installation aborted."
    exit 1
fi

DOT_DIR="$HOME/.dot"
DOT_BACKUP_DIR="$HOME/.dot.bak"
BASHRC_FILE="$HOME/.bashrc"
BASHRC_BACKUP_FILE="$HOME/.bashrc.bak"
SOURCE_ME_FILE="$DOT_DIR/.source_me"

backup_existing() {
    local source_path="$1"
    local backup_path="$2"

    if [ -e "$source_path" ]; then
        echo "Backing up existing $source_path to $backup_path"
        if [ -e "$backup_path" ]; then
            rm -fr "$backup_path"
        fi
        mv -f "$source_path" "$backup_path"
    fi
}

# Step 1: Backup existing ~/.dot
backup_existing "$DOT_DIR" "$DOT_BACKUP_DIR"

# Step 2: Backup existing ~/.bashrc and remove old one
backup_existing "$BASHRC_FILE" "$BASHRC_BACKUP_FILE"

# Step 3: Create new .bashrc
echo "Creating new .bashrc"
{
    echo "#!/bin/bash"
    echo "# This is a generated .bashrc file"
    echo "source $SOURCE_ME_FILE"
} > "$BASHRC_FILE"

# Step 4: Copy .dot folder to ~/.dot (delete if it already exists)
if [ -d "$DOT_DIR" ]; then
    echo "Removing existing $DOT_DIR"
    rm -rf "$DOT_DIR"
fi

echo "Copying $(pwd)/.dot to $DOT_DIR"
cp -r "$(pwd)"/.dot "$DOT_DIR"

echo "Installation of dotfiles finished successfully."

# In case provided option -d/--dots-only skip asking for aplications
if [ -n "$1" ]; then
    if [ "$1" = "-d" ] || [  "$1" = "--dots-only" ]; then
        exit 0
    fi
fi

# Step 9: Install third-party tools
install_bashmarks() {
    if [ -f "$HOME/.local/bin/bashmarks.sh" ]; then
        return 0
    fi
    read -rp "Do you want to install bashmarks? (yes/no): " answer

    if [ "$answer" != "yes" ]; then
        echo "Aborted."
        return 1
    fi

    local download_dir=""
    download_dir=$(mktemp -d)

    git clone https://github.com/huyng/bashmarks.git "$download_dir"

    make -C "$download_dir" install
}

install_bashmarks