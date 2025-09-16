#!/bin/bash

docker compose -f ../docker/compose.yml up -d

ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass

docker compose -f ../docker/compose.yml down

