#!/bin/bash
source /boot/firmware/rpi-vars.txt
echo ubuntu:$ubuntupassword | sudo chpasswd
echo root:$rootpassword | sudo chpasswd