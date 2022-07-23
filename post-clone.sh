#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install ansible

ansible-playbook install.yaml
./install

