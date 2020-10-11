#!/bin/bash
source /boot/firmware/rpi-vars.txt
sed -i "s|192.168.2.2/24|$net_ip_address|" /etc/netplan/config.yaml
sed -i "s/gateway4: 192.168.2.1/gateway4: $net_def_gw/" /etc/netplan/config.yaml
sed -i "s/192.168.2.1/$net_dns_ip/" /etc/netplan/config.yaml
sed -i "s/rpi.local/$net_rpi_tldn/" /etc/netplan/config.yaml

rm /etc/netplan/*-cloud-init.yaml
chmod go-r /etc/netplan/config.yaml
netplan apply
sleep 30
systemctl daemon-reload