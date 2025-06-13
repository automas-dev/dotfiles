#!/usr/bin/bash

if [ $# -ne 3 ]; then
	echo "Usage $0 <local_ip> <local_port> <remote_port>"
	exit 0
fi

LOCAL_IP=$1
LOCAL_PORT=$2
REMOTE_PORT=$3

echo "Opening port $LOCAL_IP:$LOCAL_PORT => :$REMOTE_PORT"
upnpc -a $LOCAL_IP $LOCAL_PORT $REMOTE_PORT TCP
