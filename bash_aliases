## Aliases

# restic backup
alias rrestic="RESTIC_PASSWORD_FILE=$HOME/.restic_pass restic -r sftp:tom-lan.local:/home/deepstorage/restic"

# Execute systemctl as sudo
alias ss='sudo systemctl'

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

# Quick sync local branch with remote branch
# eg. gsync local master
gsync() {
    if [ $# -eq 0 ]; then
        echo "Usage: gsync <from> [to=master]"
    else
        FROM=$1
        TO=$2
        if [ -z "$TO" ]; then
            TO=master
        fi
        git checkout $TO &&
            git pull &&
            git checkout $FROM &&
            git rebase $TO &&
            git checkout $FROM &&
            git merge $TO &&
            git push &&
            git checkout $FROM
    fi
}
#export -f gsync

# Git shorthand
alias gl='git log --oneline --graph --decorate --branches'
alias gla='gl --all'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias c='git commit -am'
alias ca='git add . && git commit -m'
alias gc='git commit'
alias gcm='git commit -m'

# vi: ft=sh
