#!/bin/bash

read -rp "This script will install dotfiles. Do you want to proceed? (yes/no): " answer

if [ "$answer" != "yes" ]; then
    echo "Installation aborted."
    exit 1
fi

dot_dir="$HOME/.dot"
dot_backup_dir="$HOME/.dot.bak"
bashrc_file="$HOME/.bashrc"
bashrc_backup_file="$HOME/.bashrc.bak"
source_me_file="$dot_dir/.source_me"
xresources_file="$HOME/.Xresources"
xresources_backup_file="$HOME/.Xresources.bak"

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
backup_existing "$dot_dir" "$dot_backup_dir"

# Step 2: Backup existing ~/.bashrc and remove old one
backup_existing "$bashrc_file" "$bashrc_backup_file"

# Step 3: Create new .bashrc
echo "Creating new .bashrc"
{
    echo "#!/bin/bash"
    echo "# This is a generated .bashrc file"
    echo "source $source_me_file"
} > "$bashrc_file"

# Step 4: Copy .dot folder to ~/.dot (delete if it already exists)
if [ -d "$dot_dir" ]; then
    echo "Removing existing $dot_dir"
    rm -rf "$dot_dir"
fi

echo "Copying .dot to $dot_dir"
cp -r .dot "$dot_dir"

echo "Installation of dotfiles finished successfully."

# Step 6: Backup existing ~/.Xresources and remove old one
backup_existing "$xresources_file" "$xresources_backup_file"

# Step 7: Copy .Xresources file to ~/.Xresources
cp ".Xresources" "$xresources_file"

read -rp "Do you want to install related applications? (yes/no): " answer

if [ "$answer" != "yes" ]; then
    echo "Installation aborted."
    exit 1
fi

install_programs() {
    local programs=("$@")
    
    for program in "${programs[@]}"; do
        read -p "Do you want to install $program? (yes/no): " answer
        if [ "$answer" = "yes" ]; then
            sudo apt install -y "$program"
        else
            echo "$program installation skipped."
        fi
    done
}

# Step 8: Install utility programs via apt-get
programs_to_install=("fzf" "bat" "minicom" "ranger")

install_programs "${programs_to_install[@]}"
