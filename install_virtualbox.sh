#!/bin/bash
sudo apt update
sudo apt install virtualbox
sudo apt install virtualbox-ext-pack
sudo usermod -a -G vboxusers $USER
#sudo systemctl reboot
