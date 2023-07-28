# LS
alias ll='ls -lh'
alias la='ls -A'

# CONFIRM BEFORE OVERWRITING SOMETHING
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# CD
alias cdl='cd_and_print() { cd $1; ls -CF; }; cd_and_print'
alias ..='cdl ..'
alias ...='cdl ../../'
alias .3='cdl ../../../'
alias .4='cdl ../../../../'
alias .5='cdl ../../../../../'

# DIFF
alias diff='diff --color'
alias diffy='diff --color -y'

# GIT
alias gs='git status'
alias gc='git commit'
alias gc-a='git commit --amend'
alias gc-an='git commit --amend --no-edit'
alias gl-p='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gl='git log --oneline | head -n 5'

# REPO
alias rs='repo status'
alias ru='repo upload'

# FZF
export FZF_DEFAULT_OPTS="--preview 'batcat {}'"
alias fzf-c='fzf --bind "enter:become(code {})"'

# PS
color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;33m\]~\u\[\033[00m\033[01;31m\]@\W\[\033[33m\] λ:\[\033[00m\] '
    PS2='\[\033[01;33m\]~\[\033[00m\] '
else
    PS1='~\u@\W λ: '
    PS2='~ '
fi
unset color_prompt

# IGNORE UPPER AND LOWERCASE WHEN TAB COMPLETION
bind "set completion-ignore-case on"

# SHOPT
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control


### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# FLAGGING USEFULL COMMANDS
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# TOP PROCS EATING MEM
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# TOP PROCS EATING CPU
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# CSV view snippet
csv_view() {
	column -s, -t < $1 | less -#2 -N -S
}

# PROCESS FINISH NOTIFIER
alias ntf='spd-say "Task finished."'

# BASHMARKS
# install by cloning https://github.com/huyng/bashmarks
source ~/.local/bin/bashmarks.sh

# C REPL
alias crepl='code main.c && watch "gcc main.c -o main && ./main"'

source ~/.workrc
