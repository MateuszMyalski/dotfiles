#!/usr/bin/env bash

alias ..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'

alias clr='clear'

alias py-venv-c='python -m venv .venv'
alias py-venv-a='source .venv/bin/activate'
alias py-venv-d='deactivate'

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -Alh'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias rs='repo status'
alias ru='repo upload'

alias grep='grep --color=auto'
alias tree='tree -L 1'
alias du='du -h --max-depth=1'

alias cdtmp='cd $(ctmp | grep -o "/tmp/.*")'

alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcr="docker compose restart"
alias dexti="docker exec -ti"

[ -f ~/.env ] && source ~/.env
[ -f ~/.bashrc_local ] && source ~/.bashrc_local

[ -f ~/.local/bin/bashmarks ] && source ~/.local/bin/bashmarks
[ -f ~/.local/bin/uart ] && source ~/.local/bin/uart
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f ~/.cargo/env ] && source ~/.cargo/env

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Workspaces/uemacs:$PATH"
