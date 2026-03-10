#!/bin/bash
set -e

echo "Создание рандомной секретной строки для webhooks github"
echo $RANDOM | md5sum | head -c 20; echo
echo "Добавьте вывод в переменную SECRET в файл atlantis.var если нужно"

echo "Параметры индивидуальные события для webhook"
echo "Issue comments ... Pull requests ... Pull request reviews ... Pushes"

echo "Подгружаем переменные из файла atlantis.var"
#. atlantis.var

echo $USERNAME

echo "Добавляем репозиторий runatlantis"
helm repo add runatlantis https://runatlantis.github.io/helm-charts

echo "Обновляем репозитории"
helm repo update

echo "Копируем в pod файл настройки .terraformrc"
kubectl -n atlantis cp /home/ubuntu/.terraformrc atlantis-0:/home/atlantis/.terraformrc

echo "Создаем рабочее пространство для atlantis с именем atlantis"
kubectl create namespace atlantis --dry-run=client -o yaml | kubectl apply -f -

echo "Создаем секреты"
kubectl -n atlantis delete secrets yandex-key-secret
kubectl -n atlantis create secret generic yandex-key-secret --from-file=/home/ubuntu/authorized-key-diplom.json
kubectl -n atlantis delete secrets s3-key-secret
kubectl -n atlantis create secret generic s3-key-secret --from-file=/home/ubuntu/credentials-diplom
kubectl -n atlantis delete secrets pub-key-secret
kubectl -n atlantis create secret generic pub-key-secret --from-file=/home/ubuntu/id_rsa.pub


#echo "Секрет для токенов и ключей S3"
#kubectl create secret generic atlantis-secrets \
#   --from-literal=ATLANTIS_GH_TOKEN="ghp_..." \
#   --from-literal=AWS_ACCESS_KEY_ID="YCA..." \
#   --from-literal=AWS_SECRET_ACCESS_KEY="YCP..."

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

  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}

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
EOF

helm upgrade --install atlantis runatlantis/atlantis  --namespace atlantis  -f value.yaml
