#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## ls commands
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -al'

## clear && ls commands
alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'

## ping commands
alias pingg='ping -c 4 google.com'
alias ping8='ping -c 4 8.8.8.8'
alias pingd='ping8'

## Terminal Colors
RED="\[$(tput setaf 1)\]"
GREEN="\[$(tput setaf 2)\]"
YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
MAGENTA="\[$(tput setaf 5)\]"
CYAN="\[$(tput setaf 6)\]"
WHITE="\[$(tput setaf 7)\]"
RESET="\[$(tput sgr0)\]"

## PS1 line
export PS1="${RESET}[${CYAN}\u@\h${RESET}] ${YELLOW}\w${RESET}\n\$ "

