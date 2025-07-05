#!/bin/sh

# Script to set up a development environment in iSH Alpine Linux
# Creates user with bash shell, doas, SSH key, and dev tools
# No password is set for the user

set -e

# === Global Configuration ===
DEV_USER="mmyalski"
DEV_HOME="/home/$DEV_USER"
DEV_SHELL="/bin/bash"
DOAS_CONF="/etc/doas.conf"
WHEEL_GROUP="wheel"
SSH_KEY="$DEV_HOME/.ssh/id_ed25519"
DOAS_RULE="permit persist :$WHEEL_GROUP"

# Function to check if a package is installed
is_installed() {
    apk info -e "$1" >/dev/null 2>&1
}

# Function to install a package if not already installed
install_package() {
    PACKAGE="$1"
    if is_installed "$PACKAGE"; then
        echo "> Package '$PACKAGE' already installed."
    else
        echo "> Installing '$PACKAGE'."
        apk add --no-cache "$PACKAGE"
    fi
}

# Create a user with no password
create_user() {
    if id "$DEV_USER" >/dev/null 2>&1; then
        echo "> User '$DEV_USER' already exists. Skipping."
    else
        echo "> Creating user '$DEV_USER'."
        adduser -h "$DEV_HOME" -s "$DEV_SHELL" "$DEV_USER"
    fi
}

# Ensure the wheel group exists and user is a member
setup_wheel_group() {
    if ! getent group "$WHEEL_GROUP" >/dev/null 2>&1; then
        echo "> Creating group '$WHEEL_GROUP'."
        addgroup "$WHEEL_GROUP"
    fi

    echo "> Adding '$DEV_USER' to group '$WHEEL_GROUP'."
    addgroup "$DEV_USER" "$WHEEL_GROUP"
}

# Configure /etc/doas.conf
configure_doas() {
    echo "> Configuring doas."
    if [ ! -f "$DOAS_CONF" ]; then
        echo "$DOAS_RULE" > "$DOAS_CONF"
    elif ! grep -Fxq "$DOAS_RULE" "$DOAS_CONF"; then
        echo "$DOAS_RULE" >> "$DOAS_CONF"
    fi
    chmod 600 "$DOAS_CONF"
}

# Generate SSH key
generate_ssh_key() {
    su - "$DEV_USER" -c "
        mkdir -p ~/.ssh && chmod 700 ~/.ssh
        if [ ! -f \"$SSH_KEY\" ]; then
            echo 'Generating ED25519 SSH key...'
            ssh-keygen -t ed25519 -f \"$SSH_KEY\" -N ''
        else
            echo 'SSH key already exists. Skipping.'
        fi
    "
}

# Git config
configure_git() {
    echo "> Configuring Git for '$DEV_USER'."
    printf "Enter Git name: "
    read GIT_NAME
    printf "Enter Git email: "
    read GIT_EMAIL

    su - "$DEV_USER" -c "git config --global user.name \"$GIT_NAME\""
    su - "$DEV_USER" -c "git config --global user.email \"$GIT_EMAIL\""
}

# Change user after logging to root
# Note: Currently using /bin/login to switch users does not work in iSH 
# (https://github.com/ish-app/ish/issues/2509)
add_change_user() {
    echo "> Switching to user '$DEV_USER'."
    echo "su - \"$DEV_USER\"" > /root/.profile
    chmod 600 /root/.profile
}

# Main setup
main() {
    echo "> Change password for root account."
    passwd

    echo "> Updating package index."
    apk update

    echo "> Installing packages."
    install_package bash
    install_package nano
    install_package git
    install_package openssh
    install_package doas
    install_package openrc
    install_package python3
    install_package gcc
    install_package make
    install_package shadow

    create_user
    setup_wheel_group
    configure_doas
    generate_ssh_key
    configure_git
    add_change_user

    echo ""
    echo "> Setup complete."
    echo "> To switch to user '$DEV_USER':"
    echo ">   su - $DEV_USER"
    echo ""
    echo "> Public SSH key:"
    cat "$SSH_KEY.pub"
}

main
