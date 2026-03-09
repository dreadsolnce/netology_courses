#!/bin/bash

set -e

echo "Подгружаем переменные из файла .env"
set -o allexport
source .env
set +o allexport

echo "Запускаем основной проект"
cd main/
terraform "$1"

#echo "Импортируем базу данных в mysql"
#BASTION_IP=$(terraform output -raw external_ip_address_bastion 2>/dev/null || echo "93.77.185.127")
#ssh -o StrictHostKeyChecking=no ubuntu@${BASTION_IP} "kubectl -n app get pods | grep mysql | cut -d' ' -f1 | xargs -I {} kubectl -n app exec pods/{} -- sh -c 'mysql -h 127.0.0.1 -P 3306 -u ${db_user} -p\"${db_password}\" ${db_name} < /tmp/animals.sql'"
