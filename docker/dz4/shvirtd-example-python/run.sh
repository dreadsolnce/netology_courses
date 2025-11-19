#/bin/bash

sudo mkdir /opt/project

sudo chown -R ${whoami}:$(whoami) /opt/project

git clone https://github.com/dreadsolnce/shvirtd-example-python.git /opt/project

cp /opt/project/.env.example /opt/project/.env

docker login --username oauth cr.yandex

docker compose -f /opt/project/compose.yaml up -d

