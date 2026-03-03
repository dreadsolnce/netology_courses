#!/bin/bash

# Нужен для того чтобы скрипт немедленно завершился в случае ошибки на каком либо этапе
set -e

cd /tmp

# Установка необходимой версии python с помощью pyenv для запуска kubespray
echo "Скачиваем и устанавливаем pyenv"
curl https://pyenv.run | /bin/bash

#echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
#echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
#echo 'eval "$(pyenv init -)"' >> ~/.bashrc
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

source ~/.bashrc

# pyenv install 3.12.7
pyenv install 3.12.7

#pyenv local 3.12.7
pyenv local 3.12.7

# Установка кластера k8s с помощью kubespray
git clone https://github.com/kubernetes-sigs/kubespray.git

cd kubespray

#git checkout  remotes/origin/release-2.30

cp -rfp inventory/sample inventory/k8s_cluster

cp ../addons.yml inventory/k8s_cluster/group_vars/k8s_cluster/addons.yml

python3 -m venv .venv

source .venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt

chmod -R 777 inventory/k8s_cluster

cp ../hosts.ini inventory/k8s_cluster/inventory.ini

# Установка с ограничением в один поток, а иначе проблема с сертификатами
# параметр -e "serial=1" ограничение в один поток
# параметр --limit <first_master_hostname> ограничивается одним узлом
ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -e "serial=1" -b cluster.yml

# Очистка
#ansible-playbook -u ubuntu -i inventory/k8s_cluster/inventory.ini -b reset.yml

cd ..

deactivate

rm -rf kubespray/

cd /home/ubuntu

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

source <(kubectl completion bash)

echo "source <(kubectl completion bash)" >> ~/.bashrc

source .bashrc

mkdir .kube

ssh master1 "sudo cp /etc/kubernetes/admin.conf /tmp/config"

scp master1:/tmp/config .kube/config

sudo chown ubuntu:ubuntu .kube/config

kubectl taint nodes master1 node-role.kubernetes.io/control-plane:NoSchedule-

kubectl taint nodes master2 node-role.kubernetes.io/control-plane:NoSchedule-

kubectl taint nodes master3 node-role.kubernetes.io/control-plane:NoSchedule-






