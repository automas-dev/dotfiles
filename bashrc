#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


## Path

export PATH="$PATH:$HOME/.local/bin:$HOME/.scripts"

## SSH Auth
if [[ ! -f $XDG_RUNTIME_DIR/ssh-agent.env ]]; then
	ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
	eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
fi

## Theme and Background

if [[ ! -f ~/.last_background ]]; then
    echo light > ~/.last_background
fi

function light() {
    . ~/.scripts/change_theme light
}

function gray() {
    . ~/.scripts/change_theme gray
}

function dark() {
    . ~/.scripts/change_theme dark
}

export BACKGROUND=$(cat ~/.last_background)
export -f light
export -f gray
export -f dark

## Aliases

alias ss='sudo systemctl'

alias ls='ls -h --color=always --group-directories-first'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'
alias clla='clear && lla'

alias ping4='ping -c 4'
alias pingg='ping4 google.com'
alias ping8='ping4 8.8.8.8'

alias df='df -h'
alias du='du -h'

alias less='less -r'

alias gcc='gcc -fdiagnostics-color=always'
alias g++='g++ -fdiagnostics-color=always'

alias push='git push'
alias pull='git pull'
alias merge='git merge'
alias commit='git commit'
alias checkout='git checkout'
alias gsync='git checkout master && git pull && git merge local && git push'
alias gl='git log --oneline --graph --decorate --branches'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias c='git commit -am'
alias ca='git add . && git commit -m'
alias gc='git commit'
alias gcm='git commit -m'

## Terminal Colors
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
RESET="\[\e[0m\]"

## PS1 Line

check_git() {
	git branch 2>&1 | grep -i "^\*"
}

check_ssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		echo SSH
	fi
}

# Full PS1 line
#export PS1="${RED}[${YELLOW}\u${GREEN}@${CYAN}\h ${MAGENTA}\w${RED}]${YELLOW}\$(check_git)${RESET}\n${YELLOW}\$(check_ssh)${WHITE}\$ ${RESET}"

# Minimal PS1 line
export PS1="${RED}[${MAGENTA}\w${RED}]${YELLOW}\$(check_git) \$(check_ssh)${WHITE}\$ ${RESET}"
