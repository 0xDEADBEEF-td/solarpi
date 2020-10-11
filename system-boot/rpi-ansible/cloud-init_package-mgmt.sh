#!/bin/bash
systemctl restart systemd-timesyncd
sleep 10
apt-get update
apt-get upgrade -y
apt-get install ansible sshpass -y