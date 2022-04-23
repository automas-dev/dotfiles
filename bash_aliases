## Aliases

alias dps='docker ps -a --format="table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias dc="docker compose"
alias dcf="dc -f"

# xclip to clipboard
alias clip="xclip -selection clipboard"

# restic backup
alias rrestic="RESTIC_PASSWORD_FILE=$HOME/.restic_pass restic -r sftp:tom-lan.local:/home/deepstorage/restic"

# Execute systemctl as sudo
alias ss='sudo systemctl'
alias userctl='systemctl --user'

# ls with human redable, color and directories first
alias ls='ls -h --color=always --group-directories-first'

# ls shorthand
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Clear and ls shorthand
alias cls='clear && ls'
alias cll='clear && ll'
alias cla='clear && la'
alias clla='clear && lla'

# Human redable df and du
alias df='df -h'
alias du='du -h'

# Less use raw control caracters (allow color)
alias less='less -r'

# gcc and g++ color output
alias gcc='gcc -fdiagnostics-color=always'
alias g++='g++ -fdiagnostics-color=always'

# color grep
alias grep="grep --color=auto"

# Git shorthand
alias gl='git log --oneline --graph --decorate --branches'
alias gla='gl --all'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias c='git commit -am'
alias ca='git add . && git commit -m'
alias gc='git commit'
alias gcm='git commit -m'

gt() {
    tag="$1"
    git tag -a "$tag" -m "$tag"
}

# vi: ft=sh
