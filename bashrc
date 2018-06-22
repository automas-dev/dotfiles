#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## ls commands
alias ls='ls -h --color=auto'
alias ll='ls -l'
alias la='ls -al'

## clear && ls commands
alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'

## ping commands
alias ping4='ping -c 4'
alias pingg='ping4 google.com'
alias ping8='ping4 8.8.8.8'
alias pingd='ping8'

# color grep
alias cgrep='grep --color=always'

# color less
alias less='less -r'

## Terminal Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
RESET="\e[0m"

## PS1 line
check_git() {
	if [ -d '.git' ]; then
		git branch
	fi
}
export PS1="${RESET}[${CYAN}\u${WHITE}@${GREEN}\h${RESET}] ${YELLOW}\w${MAGENTA}\$(check_git)${RESET}\n\$ "

## Rust Lang config
CARGO_INCREMENTAL=1

## umask for gi script
umask 002

