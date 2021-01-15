#!/usr/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage $0 <remote_port>"
	exit 0
fi

REMOTE_PORT=$1

echo "Closing port :$REMOTE_PORT"
upnpc -d $REMOTE_PORT

