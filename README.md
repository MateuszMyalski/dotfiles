# How to install
1. Set `install.sh` as executable `chmod +x install.sh`
2. Execute the script "./install.sh"

# Hooks
The auto-update feature of the dotfiles relies on number stored in `.version` file. To always keep updated dotfiles this number should be incremented every commit. This work is automated via git hook.
To configure:
1. `chmod +x hooks/pre-commit.sh`
2. `ln -s hooks/pre-commit.sh .git/hooks/`