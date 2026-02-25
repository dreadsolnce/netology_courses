#!/bin/bash

#git clone https://github.com/kubernetes-sigs/kubespray.git
#
cd kubespray
#
#python3 -m venv .venv
#
source .venv/bin/activate
#
#pip install --upgrade pip
#
#pip install -r requirements.txt
#
#cp -rfp inventory/sample inventory/k8s_cluster
#
#chmod -R 777 inventory/k8s_cluster

cp ../../main/hosts.ini inventory/k8s_cluster/inventory.ini

ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -b cluster.yml
