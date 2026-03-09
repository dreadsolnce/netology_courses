#!/bin/bash
#set -e

echo "Создание рандомной секретной строки для webhooks github"
echo $RANDOM | md5sum | head -c 20; echo
echo "Добавьте вывод в переменную SECRET в файл atlantis.var если нужно"

echo "Параметры индивидуальные события для webhook"
echo "Issue comments ... Pull requests ... Pull request reviews ... Pushes"

#echo "Подгружаем переменные из файла atlantis.var"
#. atlantis.var

echo "Проверка что подгрузились переменные окружения"
echo $USERNAME

echo "Добавляем репозиторий runatlantis"
helm repo add runatlantis https://runatlantis.github.io/helm-charts

echo "Обновляем репозитории"
helm repo update

echo "Создаем рабочее пространство для atlantis с именем atlantis"
kubectl create namespace atlantis --dry-run=client -o yaml | kubectl apply -f -

#kubectl -n atlantis delete secrets yandex-key-secret
#kubectl -n atlantis create secret generic yandex-key-secret --from-file=/home/ubuntu/key.json
#
##echo "Секрет для токенов и ключей S3"
##kubectl create secret generic atlantis-secrets \
##   --from-literal=ATLANTIS_GH_TOKEN="ghp_..." \
##   --from-literal=AWS_ACCESS_KEY_ID="YCA..." \
##   --from-literal=AWS_SECRET_ACCESS_KEY="YCP..."

echo "Создаем файл value.yaml для atlantis со своими настройками"
cat <<EOF > value.yaml
orgAllowlist: ${REPO_ALLOWLIST}

github:
  user: ${USERNAME}
  token: ${TOKEN}
  secret: ${SECRET}

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
  YC_CLOUD_ID: ${YC_CLOUD_ID}
  YC_FOLDER_ID: ${YC_FOLDER_ID}

#  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
#  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
#
#  YC_SERVICE_ACCOUNT_KEY_FILE: "/etc/atlantis/key.json"
## Указываем ссылку на созданный выше секрет
##vcsTokenSecretName: atlantis-vcs-secrets
##vcsTokenSecretKey: github-token
##vcsWebhookSecretName: atlantis-vcs-secrets
##vcsWebhookSecretKey: github-webhook-secret
#
#extraVolumes:
#  - name: yandex-key-volume
#    secret:
#      secretName: yandex-key-secret
#      items:
#        - key: key.json
#          path: key.json
#extraVolumeMounts:
#  - name: yandex-key-volume
#    mountPath: /etc/atlantis
#    readOnly: true

EOF

echo "Создание секрета через kubectl"
#kubectl create secret generic atlantis-vcs-secrets --namespace atlantis --from-literal=github-token='ghp_ВашРеальныйТокенИзШага1' --from-literal=github-webhook-secret='ВашСекретВебхука'

helm upgrade --install atlantis runatlantis/atlantis  --namespace atlantis  -f value.yaml
