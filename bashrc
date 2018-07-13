#
# ~/.bashrc
#

#  _____ _                                   ____            _     ____   ____ 
# |_   _| |__   ___  _ __ ___   __ _ ___    | __ )  __ _ ___| |__ |  _ \ / ___|
#   | | | '_ \ / _ \| '_ ` _ \ / _` / __|   |  _ \ / _` / __| '_ \| |_) | |    
#   | | | | | | (_) | | | | | | (_| \__ \  _| |_) | (_| \__ \ | | |  _ <| |___ 
#   |_| |_| |_|\___/|_| |_| |_|\__,_|___/ (_)____/ \__,_|___/_| |_|_| \_\\____|
                                                                            
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## umask for gi script
umask 002


#    _   _ _                 
#   /_\ | (_)__ _ ___ ___ ___
#  / _ \| | / _` (_-</ -_|_-<
# /_/ \_\_|_\__,_/__/\___/__/
                           
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

## Human Readable df
alias df='df -h'

# color grep
alias cgrep='grep --color=always'

# color less
alias less='less -r'


#   ___     _            
#  / __|___| |___ _ _ ___
# | (__/ _ \ / _ \ '_(_-<
#  \___\___/_\___/_| /__/
                       
## Terminal Colors
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
RESET="\[\e[0m\]"

## PS1 line
check_git() {
	if [ -d '.git' ]; then
		git branch
	fi
}
check_ssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		echo @SSH@
	fi
}
export PS1="\$(check_ssh)${RED}[${YELLOW}\u${GREEN}@${CYAN}\h ${MAGENTA}\w${RED}]${MAGENTA}\$(check_git)${RESET}\n${WHITE}\$ ${RESET}"

