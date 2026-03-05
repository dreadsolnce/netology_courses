#!/bin/bash
set -e

echo "Создание рандомной секретной строки для webhooks github"
echo $RANDOM | md5sum | head -c 20; echo
echo "Добавьте вывод в переменную SECRET в файл atlantis.var если нужно"

echo "Параметры индивидуальные события для webhook"
echo "Issue comments ... Pull requests ... Pull request reviews ... Pushes"

echo "Подгружаем переменные из файла atlantis.var"
. atlantis.var

echo $USERNAME

echo "Добавляем репозиторий runatlantis"
helm repo add runatlantis https://runatlantis.github.io/helm-charts

echo "Обновляем репозитории"
helm repo update

echo "Создаем рабочее пространство для atlantis с именем atlantis"
kubectl create namespace atlantis --dry-run=client -o yaml | kubectl apply -f -

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
EOF

echo "Установка простого StorageClass. Можно не делать т.к. он был включен в addons.yaml"
#kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

helm upgrade --install atlantis runatlantis/atlantis  --namespace atlantis  -f value.yaml

