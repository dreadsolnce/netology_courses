#!/bin/bash
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install yc-agent gitlab/gitlab-agent \
    --namespace gitlab-agent-yc-agent \
    --create-namespace \
    --set config.token=${TOKEN_GITLAB} \
    --set config.kasAddress=wss://kas.gitlab.com


# Также заменить строку в app.yml на __IMAGE__

#  gitlab-runner register --url https://gitlab.com --token glrt-6IXFrizF8ekcFT5D4NuPMm86MQpwOjFicTc1dQp0OjMKdTpoNHQzYxg.01.1j0qarn20
# nohup gitlab-runner run >/dev/null 2>&1 &