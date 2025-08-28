#!/bin/bash
wget https://hashicorp-releases.yandexcloud.net/packer/1.14.1/packer_1.14.1_linux_amd64.zip -P ~/packer
unzip ~/packer/packer_1.14.1_linux_amd64.zip -d ~/packer
sudo cp ~/packer/packer /usr/local/bin/packer
rm -r ~/packer
packer --version
touch ~/.config/config.pkr.hcl 
echo "packer {" > ~/.config/config.pkr.hcl
echo "  required_plugins {" >> ~/.config/config.pkr.hcl
echo "    yandex = {" >> ~/.config/config.pkr.hcl
echo '     version = ">= 1.1.2"' >> ~/.config/config.pkr.hcl
echo '     source  = "github.com/hashicorp/yandex"' >> ~/.config/config.pkr.hcl
echo "    }" >> ~/.config/config.pkr.hcl
echo "  }" >> ~/.config/config.pkr.hcl
echo "}" >> ~/.config/config.pkr.hcl
packer init ~/.config/config.pkr.hcl
