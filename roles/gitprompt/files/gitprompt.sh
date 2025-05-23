COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
# 256 color orange
COLOR_ORANGE="\e[38;5;214m"
COLOR_RESET="\033[0m"

function ssh_session {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo -e "ssh"
  fi
}

function ros_version {
  local ros_version="$(printenv ROS_DISTRO 2> /dev/null)"
  if [ -f /.dockerenv ] && [ -n "$ros_version" ]; then
    echo "$ros_version"
  fi
}

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working tree clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_BLUE
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

PS1="\[${COLOR_WHITE}\]"
PS1+="$(ssh_session)"
PS1+="\[$COLOR_ORANGE\]"
PS1+="$(ros_version)"
PS1+="\[$COLOR_GREEN\][\w]"  # basename of pwd
PS1+="\[\$(git_color)\]"     # colors git status
PS1+="\$(git_branch)"        # prints current branch
PS1+="\[$COLOR_ORANGE\]\$\[$COLOR_RESET\] "   # '#' for root, else '$'
export PS1
