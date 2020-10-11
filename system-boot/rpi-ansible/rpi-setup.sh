#!/bin/bash

sudo -H -u ubuntu bash -c 'ansible -m ping rpi -u root'
sudo -H -u ubuntu bash -c 'ansible -m ping rpi -u ubuntu'
sudo -H -u ubuntu bash -c 'ansible-playbook /home/ubuntu/ansible/rpi_microk8s_setup_playbook.yaml -vv'

