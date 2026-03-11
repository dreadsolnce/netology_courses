#!/bin/bash
# Добавляем репу
helm repo add gitlab https://charts.gitlab.io/

# Обновляем репы
helm repo update

# Создаем namespace если он не создан
kubectl create namespace gitlab --dry-run=client -o yaml | kubectl apply -f -

# Устанавливаем gitlab
helm upgrade --install gitlab gitlab/gitlab \
    --namespace gitlab \
    -f gitlab.yaml \
    --timeout 600s

