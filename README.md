# How to install
1. Set `install.sh` as executable `chmod +x install.sh`
2. Execute the script "./install.sh"

# Hooks
The auto-update feature of the dotfiles relies on number stored in `.version` file. To always keep updated dotfiles this number should be incremented every commit. This work is automated via git hook.
To configure:
1. `cp hooks/pre-commit.sh .git/hooks/pre-commit`
2. `chmod +x .git/hooks/pre-commit`

# Themes
1. Main theme [Andromeda](https://www.xfce-look.org/p/2039961)
2. Icons [Argon](https://www.xfce-look.org/p/1490645)
