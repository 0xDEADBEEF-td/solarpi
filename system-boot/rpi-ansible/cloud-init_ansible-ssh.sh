#!/bin/bash
source /boot/firmware/rpi-vars.txt

#Get the IP without subnet from CIDR value
ip=$(echo $net_ip_address | sed 's/[/].*$//')

#Update the hosts file
echo "$ip rpi" >> /etc/hosts

#Update the Ansible hosts file
cat << EOF >> /etc/ansible/hosts
[rpi]
$ip
EOF

#Generat the SSH keys for user ubuntu, add our SSH keys to known hosts, and do the key copy
sudo -H -u ubuntu bash -c "ssh-keygen -t rsa -b 4096 -q -P '' -f ~/.ssh/id_rsa"
sudo -H -u ubuntu bash -c "ssh-keyscan $ip >> /home/ubuntu/.ssh/known_hosts"
sudo -H -u ubuntu bash -c "echo $ubuntupassword > /home/ubuntu/ubuntupass"
sudo -H -u ubuntu bash -c "echo $rootpassword > /home/ubuntu/rootpass"
sudo -H -u ubuntu bash -c "sshpass -v -f /home/ubuntu/rootpass ssh-copy-id root@$ip"
sudo -H -u ubuntu bash -c "sshpass -v -f /home/ubuntu/ubuntupass ssh-copy-id ubuntu@$ip"
sudo -H -u ubuntu bash -c "rm /home/ubuntu/ubuntupass"
sudo -H -u ubuntu bash -c "rm /home/ubuntu/rootpass"

#Set the proper values in the Ansible playbook from rpi-vars.txt
sed -i "s|rpi_internal_ip='192.168.2.2'|rpi_internal_ip='$ip'|" /boot/firmware/rpi-ansible/rpi_microk8s_setup_playbook.yaml
sed -i "s|internal_network_metallb_start_ip='192.168.2.3'|internal_network_metallb_start_ip='$net_metallb_start_ip'|" /boot/firmware/rpi-ansible/rpi_microk8s_setup_playbook.yaml
sed -i "s|internal_network_metallb_end_ip='192.168.2.7'|internal_network_metallb_end_ip='$net_metallb_end_ip'|" /boot/firmware/rpi-ansible/rpi_microk8s_setup_playbook.yaml
sed -i "s|microk8s_info_top_domain='fakeboot.local'|microk8s_info_top_domain='$net_rpi_tldn'|" /boot/firmware/rpi-ansible/rpi_microk8s_setup_playbook.yaml

#Setup the service to run the Ansible playbooks at next boot
cp /boot/firmware/rpi-ansible/rpi-setup.service /etc/systemd/system/
chmod 664 /etc/systemd/system/rpi-setup.service
sudo -H -u ubuntu bash -c 'mkdir /home/ubuntu/ansible'
cp /boot/firmware/rpi-ansible/* /home/ubuntu/ansible/
chmod -R 744 /home/ubuntu/ansible/*
chown -R ubuntu:ubuntu /home/ubuntu/ansible/*
systemctl daemon-reload
systemctl enable rpi-setup.service