#!/bin/bash

read -rp "This script will install dotfiles. Do you want to proceed? (yes/no): " answer

if [ "$answer" != "yes" ]; then
    echo "Installation aborted."
    return 1
fi

DOT_DIR="$HOME/.dot"
DOT_BACKUP_DIR="$HOME/.dot.bak"
BASHRC_FILE="$HOME/.bashrc"
BASHRC_BACKUP_FILE="$HOME/.bashrc.bak"
SOURCE_ME_FILE="$DOT_DIR/.source_me"
XRESOURCES_FILE="$HOME/.Xresources"
XRESOURCES_BACKUP_FILE="$HOME/.Xresources.bak"

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

echo "Copying $(dirname \$0)/.dot to $DOT_DIR"
cp -r "$(dirname \$0)"/.dot "$DOT_DIR"

echo "Installation of dotfiles finished successfully."

# Step 6: Backup existing ~/.Xresources and remove old one
backup_existing "$XRESOURCES_FILE" "$XRESOURCES_BACKUP_FILE"

# Step 7: Copy .Xresources file to ~/.Xresources
cp ".Xresources" "$XRESOURCES_FILE"


# Step 8: Install utility programs via apt-get
install_apt_programs() {
    read -rp "Do you want to install related applications via apt? (yes/no): " answer

    if [ "$answer" != "yes" ]; then
        echo "Aborted."
        return 1
    fi

    local programs_to_install=("fzf" "bat" "minicom" "ranger" "urxvt-unicode")
    
    for program in "${programs_to_install[@]}"; do
        read -rp "Do you want to install $program? (yes/no): " answer
        if [ "$answer" = "yes" ]; then
            sudo apt install -y "$program"
        else
            echo "$program installation skipped."
        fi
    done
}

install_apt_programs

# Step 9: Install third-party tools
install_bashmarks() {
    read -rp "Do you want to install bashmarks? (yes/no): " answer

    if [ "$answer" != "yes" ]; then
        echo "Aborted."
        return 1
    fi

    local download_dir=""
    download_dir=$(mktemp -d)

    git clone https://github.com/huyng/bashmarks.git "$download_dir"

    make -C "$download_dir"/install.sh install
}

install_bashmarks