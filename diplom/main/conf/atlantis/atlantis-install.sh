#!/bin/bash
#set -e

echo "Создание рандомной секретной строки для webhooks github"
echo $RANDOM | md5sum | head -c 20; echo
echo "Добавьте вывод в переменную SECRET в файл atlantis.var если нужно"

echo "Параметры индивидуальные события для webhook"
echo "Issue comments ... Pull requests ... Pull request reviews ... Pushes"

echo "Проверяем что переменные подгрузились в скрипт"
echo "Имя пользователя github: ${USERNAME}"

echo "Добавляем репозиторий runatlantis"
helm repo add runatlantis https://runatlantis.github.io/helm-charts

echo "Обновляем репозитории"
helm repo update

echo "Создаем рабочее пространство для atlantis с именем atlantis"
kubectl create namespace atlantis --dry-run=client -o yaml | kubectl apply -f -

echo "Создаем секреты"
echo "Секрет для ключа (файла) авторизации сервисного акаунта"
kubectl -n atlantis create secret generic yandex-key-secret --from-file=/home/ubuntu/authorized-key-diplom.json --dry-run=client -o yaml | kubectl apply -f -
echo "Секрет для ключа авторизации к s3 бакету"
kubectl -n atlantis create secret generic s3-key-secret --from-file=/home/ubuntu/credentials-diplom --dry-run=client -o yaml | kubectl apply -f -
echo "Секрет для публичного ключа"
kubectl -n atlantis create secret generic pub-key-secret --from-file=/home/ubuntu/id_rsa.pub --dry-run=client -o yaml | kubectl apply -f -
echo "Секрет для токена github и секрета (webhook) github"
kubectl -n atlantis create secret generic atlantis-vcs-secrets \
   --from-literal=github_token="${TOKEN}" \
   --from-literal=github_secret="${SECRET}" \
   --dry-run=client -o yaml | kubectl apply -f -

echo "Создаем configMap с содержимым файла .terraformrc"
kubectl -n atlantis create configmap atlantis-terraformrc --from-file=.terraformrc=/home/ubuntu/.terraformrc --dry-run=client -o yaml | kubectl apply -f -

echo "Создаем файл value.yaml для atlantis со своими настройками"
cat <<EOF > value.yaml
orgAllowlist: ${REPO_ALLOWLIST}

github:
  user: ${USERNAME}
vcsSecretName: atlantis-vcs-secrets

service:
  type: NodePort
  port: 80
  targetPort: 4141
  nodePort: 30141

atlantisUrl: ${URL}:30141

volumeClaim:
  enabled: true
  size: 5Gi
  storageClassName: "local-path"
  accessModes:
    - ReadWriteOnce

environment:
  TF_VAR_yc_cloud_id: ${YC_CLOUD_ID}
  TF_VAR_yc_folder_id: ${YC_FOLDER_ID}
  TF_VAR_db_host: ${DB_HOST}
  TF_VAR_db_user: ${DB_USER}
  TF_VAR_db_password: ${DB_PASSWORD}
  TF_VAR_db_name: ${DB_NAME}
  TF_VAR_mysql_root_password: ${MYSQL_ROOT_PASSWORD}
  TF_VAR_secret: ${SECRET}
  TF_VAR_token: ${TOKEN}
  TF_VAR_url: ${URL}
  TF_VAR_username: ${USERNAME}
  TF_VAR_repo_github: ${REPO_ALLOWLIST}

extraVolumes:
  - name: yandex-key-volume
    secret:
      secretName: yandex-key-secret
      items:
        - key: authorized-key-diplom.json
          path: authorized-key-diplom.json
  - name: s3-key-volume
    secret:
      secretName: s3-key-secret
      items:
        - key: credentials-diplom
          path: credentials-diplom
  - name: pub-key-volume
    secret:
      secretName: pub-key-secret
      items:
        - key: id_rsa.pub
          path: id_rsa.pub
  - name: terraformrc
    configMap:
      name: atlantis-terraformrc

extraVolumeMounts:
  - name: yandex-key-volume
    mountPath: /home/atlantis/keys
    readOnly: true
  - name: s3-key-volume
    mountPath: /home/atlantis/.aws
    readOnly: true
  - name: pub-key-volume
    mountPath: /home/atlantis/.ssh
    readOnly: true
  - name: terraformrc
    mountPath: /home/atlantis/
#    subPath: .terraformrc                       # Важно, чтобы не перетереть всю папку /home/atlantis
    readOnly: true

EOF

helm upgrade --install atlantis runatlantis/atlantis  --namespace atlantis  -f value.yaml

