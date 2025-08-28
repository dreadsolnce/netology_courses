#!/bin/bash

wget https://hashicorp-releases.yandexcloud.net/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip

apt install unzip

unzip terraform_1.9.8_linux_amd64.zip

mv terraform /usr/bin/

rm terraform_1.9.8_linux_amd64.zip

rm LICENSE.txt
