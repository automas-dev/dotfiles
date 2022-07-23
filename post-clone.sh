#!/bin/bash

set -e

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get -y install ansible

ansible-playbook install.yaml
./install

