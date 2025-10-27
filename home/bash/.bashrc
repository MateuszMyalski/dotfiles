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

[ -f ~/.env ] && source ~/.env
[ -f ~/.bashrc_local ] && source ~/.bashrc_local

[ -f ~/.local/bin/bashmarks ] && source ~/.local/bin/bashmarks
[ -f ~/.local/bin/uart ] && source ~/.local/bin/uart
[ -f /etc/bash_completion ] && source /etc/bash_completion

export PATH="$HOME/.local/bin:$PATH"