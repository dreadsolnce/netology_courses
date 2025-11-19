#!/bin/bash


MYSQL_ROOT_PASSWORD=$(cat /opt/project/.env | grep MYSQL_ROOT_PASSWORD | awk -F= '{print $2}')
MYSQL_DATABASE=$(cat /opt/project/.env | grep  MYSQL_DATABASE| awk -F= '{print $2}')

docker run --rm --env-file /opt/project/.env  --entrypoint "" -v /opt/backup:/backup --link=mysql:alias --network=project_backend my-mysqldump:latest mysqldump --opt -h alias -u root -p"${MYSQL_ROOT_PASSWORD}" "--result-file=/backup/dumps.sql_$(date +%F_%T)" ${MYSQL_DATABASE}

