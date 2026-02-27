#!/bin/bash

# Нужен для того чтобы скрипт немедленно завершился в случае ошибки на каком либо этапе
set -e

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

cp ../../main/hosts.ini inventory/k8s_cluster/inventory.ini

# Установка с ограничением в один поток, а иначе проблема с сертификатами
# параметр -e "serial=1" ограничение в один поток
# параметр --limit <first_master_hostname> ограничивается одним узлом
ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -e "serial=1" -b cluster.yml -vvv

# Очистка
#ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -b reset.yml

cd ..

deactivate

rm -rf kubespray/

