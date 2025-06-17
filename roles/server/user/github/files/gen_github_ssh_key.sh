#!/bin/bash

GITHUB_USER_HOME=${GITHUB_USER_HOME:-${GITHUB_USER_HOME}}

read -p "Enter the github repo name: " repo_name
printf -v keygen_date '%(%Y-%m-%d)T' -1

KEY_NAME="${repo_name}_${keygen_date}"

echo "Generating key for ${KEY_NAME}"

mkdir -p "${GITHUB_USER_HOME}/.ssh/github"
ssh-keygen -b 4096 -t ed25519 -C "${repo_name}" -f "${GITHUB_USER_HOME}/.ssh/github/${KEY_NAME}" -N ""
cat "${GITHUB_USER_HOME}/.ssh/github/${KEY_NAME}.pub" >> ${GITHUB_USER_HOME}/.ssh/authorized_keys
cat "${GITHUB_USER_HOME}/.ssh/github/${KEY_NAME}"
