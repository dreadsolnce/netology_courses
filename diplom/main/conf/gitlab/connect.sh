#!/bin/bash

echo "Устанавливаем gitlab agent для связки GitLab и Kubernetes"
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install yc-agent gitlab/gitlab-agent \
    --namespace gitlab-agent-yc-agent \
    --create-namespace \
    --set config.token=${TOKEN_GITLAB_AGENT} \
    --set config.kasAddress=wss://kas.gitlab.com
echo "Не забудь добавить в variables на сайте gitlab следующие переменные:"
echo "YC_REGISTRY_ID - id яндекс registry"
echo "YC_SA_KEY - полное содержимое json ключа сервис акаунта"

echo "Устанавливаем gitlab-runner"
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt install gitlab-runner -y
sudo gitlab-runner status
sudo gitlab-runner register --executor shell --url https://gitlab.com --token ${TOKEN_GITLAB_RUNNER} --non-interactive
nohup gitlab-runner run >/dev/null 2>&1 &
echo "Не забудь создать на сайте gitlab раннера если не создал"

echo "Добавляем пользователя gitlab-runner в группу docker"
sudo usermod -aG docker gitlab-runner

echo "Изменяем файл app.yml для работы с gitlab после того как он задеплоился с образом по умолчанию kolchinvladimir/app-animals:1.0.5"
sed -i 's|kolchinvladimir/app-animals:1.0.5|__IMAGE__|g' /home/ubuntu/app.yml
