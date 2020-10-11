# solarpi
Automated Ubuntu 20.04 w/ microk8s for rpi4 consuming modbus data

- Minimum Requirements:
  - Raspberry Pi 4 w/ minimum 4GB RAM, 32GB SD
  - Wired ethernet network with non-proxied Internet access (wireless card configuration under dev for automated boot)
  - Knowledge of your default gateway and DNS server on your local LAN
  - An available range of 5 additional contiguous IP addresses on your local LAN

- Flashing/Customization Instructions:
  - Download raspi-imager (https://www.raspberrypi.org/downloads/)
   - Flash your SD card with Ubuntu Server 20.04.1 (64-bit) for Raspberry Pi 3/4
   - Once flash/verify is complete, copy the contents of 'system-boot' of this project into the system-boot partition of the SD card
     - For example, you should be prompted to overwrite the files:
       - cmdline.txt
       - network-config
       - user-data
     - And you should now see an 'rpi-ansible' directory in the root of the system-boot partition as well
   - Open the file 'rpi-vars.txt' in the root of the system-boot partition and edit the following:
   
     - ubuntupassword='default'
       - This is the password that will be assigned to the 'ubuntu' user on the rpi
       
     - rootpassword='default'
       - This is the password that will be assigned to the 'root' user on the rpi
       
     - net_ip_address='192.168.1.10/24'
       - This is the primary IP address that your rpi will have assigned to eth0 on your local LAN in CIDR format. Please enter a value with the correct IP and netmask value, and choose an IP address outside of your local LAN DHCP range.
     
     - net_def_gw='192.168.1.1'
       - This is your default gateway on your local LAN. Typically the internal IP address of your router.
       
     - net_dns_ip='192.168.1.1'
       - This is your local LAN DNS resolver. Typically the internal IP address of your router.
       
     - net_rpi_tldn='lan.local'
       - This is the local domain name on your local LAN (the hostname 'rpi' will be added to this for your FQDN, i.e, rpi.lan.local).
     
     - net_metallb_start_ip='192.168.1.11'
       - This is the starting IP of the 5 contiguous additional IP addresses needed on your local LAN. Please ensure these IP addresses are not assigned to other devices or within your local DHCP range.
     
     - net_metallb_end_ip='192.168.1.15'
       - This is the ending IP of the 5 contiguous additional IP addresses needed on your local LAN. Please ensure these IP addresses are not assigned to other devices or within your local DHCP range.
   
   - Save the 'rpi-vars.txt' file and cleanly unmount the SD card
 
 - Boot Instructions:
   - Ensure your rpi wired (eth0) interface is plugged into your local LAN and your local LAN has non-proxied Internet access
   - Connect a display so you can watch the boot progress
   - Place the SD card into the rpi and power on
   - Have another system on the LAN available with an SSH client (i.e., putty, ssh, etc...)
   
 - Watching/Validating Installation:
   - Ubuntu uses cloud-init to customize the system. It will usually take about 15-30 seconds after seeing the initial system boot until you can ping the rpi on the LAN.
   - Once you are able to ping the rpi using the 'net_ip_address' in the rpi-vars.txt file, you can attempt to access the rpi via ssh on the local LAN.
     - If the password for ubuntu user does not seem to work, continue trying every 5-10 seconds. The user passwords and SSH daemon conifguration may not be complete yet.
   - Once you have logged in via SSH, you can observe the progress of the system customization by tailing the cloud-init-output.log:
     - tail /var/log/cloud-init-output.log
       - Once cloud-init finishes, it will close your SSH connection and reboot the rpi. Wait for it to reboot and login via SSH again as user ubuntu.
   - To observe the progress of microk8s, mqtt, influxdb, grafana, and telegraf installations, use journalctl:
     - journalctl -u rpi-setup.service -f
       - Once the setup of microk8s and associated pods is complete, the rpi will reboot and is ready for use.

 - Total installation time, depending on Internet connection speed, is typically 20-30 minutes. 
