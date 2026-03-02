#!/bin/bash

# Нужен для того чтобы скрипт немедленно завершился в случае ошибки на каком либо этапе
set -e

sudo chown -R ubuntu:ubuntu /home/ubuntu

curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

source ~/.bashrc

pyenv install 3.12.7

pyenv local 3.12.7

git clone https://github.com/kubernetes-sigs/kubespray.git

cd kubespray

#git checkout  remotes/origin/release-2.30

cp -rfp inventory/sample inventory/k8s_cluster

cp ../addons.yml inventory/k8s_cluster/group_vars/k8s_cluster/addons.yml

python3 -m venv .venv

source .venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

#pip install passlib

chmod -R 777 inventory/k8s_cluster

cp ../hosts.ini inventory/k8s_cluster/inventory.ini

# Установка с ограничением в один поток, а иначе проблема с сертификатами
# параметр -e "serial=1" ограничение в один поток
# параметр --limit <first_master_hostname> ограничивается одним узлом
ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -e "serial=1" -b cluster.yml -vvv

# Очистка
#ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -b reset.yml

cd ..

deactivate

rm -rf kubespray/

#curl https://pyenv.run | bash
#echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
#echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
#echo 'eval "$(pyenv init -)"' >> ~/.bashrc
#source ~/.bashrc
#sudo apt-get install libssl-dev
#sudo apt-get install liblzma-dev
#sudo apt-get install python3-tk
#sudo apt-get install libsqlite3-dev
#sudo apt install libreadline-dev
#sudo apt-get install libffi-dev
#sudo apt-get install -y libncurses5-dev libncursesw5-dev
#sudo apt-get install libbz2-dev
#sudo apt install build-essential
#sudo apt install gcc
#python3-pip
#pyenv install 3.12.7
#