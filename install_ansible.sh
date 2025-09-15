#!/bin/bash

mkdir ansible

cd ansible/

python3 -m venv venv_ansible

source venv_ansible/bin/activate

pip3 install ansible

deactivate