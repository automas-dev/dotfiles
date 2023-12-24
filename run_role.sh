#!/bin/bash

# https://stackoverflow.com/a/38419466

if [ $# -lt 2 ]; then
  cat <<HELP
Usage: $0 <host-pattern> <role-name> [ansible-playbook options]

Wrapper script for ansible-playbook to apply single role.

Examples:
  $0 dest_host my_role
  $0 custom_host my_role -i 'custom_host,' -vv --check
HELP
  exit 1
fi

HOST_PATTERN=$1
shift
ROLE=$1
shift

echo "Trying to apply role \"$ROLE\" to host/group \"$HOST_PATTERN\"..."

export ANSIBLE_ROLES_PATH="$PWD/roles"
export ANSIBLE_RETRY_FILES_ENABLED="False"
ansible-playbook "$@" /dev/stdin <<PLAYBOOK
---
- hosts: $HOST_PATTERN
  roles:
    - $ROLE
PLAYBOOK
