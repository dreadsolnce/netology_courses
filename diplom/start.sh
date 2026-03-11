#!/bin/bash

set -e

echo -e "Перед началом необходимо создать новый токен для пректа\nв gitlab и добавить его в перемнную TF_VAR_token_gitlab"
echo "Нажми любую клавишу..."
read -n 1

echo "Подгружаем переменные из файла .env"
set -o allexport
source .env
set +o allexport

echo "Создаем файл personal.auto.tfvars"

cat <<EOF > main/personal.auto.tfvars
  yc_cloud_id = "${TF_VAR_yc_cloud_id}"
  yc_folder_id = "${TF_VAR_yc_folder_id}"

  auth_key_sa_yandex = "${TF_VAR_auth_key_sa_yandex}"
  auth_key_s3 = "${TF_VAR_auth_key_s3}"
  ssh_public_key = "${TF_VAR_ssh_public_key}"

  db_host = "${TF_VAR_db_host}"
  db_user = "${TF_VAR_db_user}"
  db_password = "${TF_VAR_db_password}"
  db_name = "${TF_VAR_db_name}"
  mysql_root_password = "${TF_VAR_mysql_root_password}"

  secret = "${TF_VAR_secret}"
  token = "${TF_VAR_token}"
  url = "${TF_VAR_url}"
  username = "${TF_VAR_username}"
  repo_github = "${TF_VAR_repo_github}"
EOF

echo "Запускаем основной проект"
cd main/
terraform "$1"
