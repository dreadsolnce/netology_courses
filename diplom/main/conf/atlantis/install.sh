#!/bin/bash
helm repo add runatlantis https://runatlantis.github.io/helm-charts
helm repo update

kubectl create namespace atlantis

mkdir -p .kube
sudo cp /etc/kubernetes/admin.conf .kube/config
sudo chown -R ubuntu:ubuntu .kube/

helm install atlantis runatlantis/atlantis -f /home/kvl/netology_courses/diplom/main/conf/atlantis/values.yml -n atlantis
# helm -n atlantis uninstall atlantis
# helm upgrade atlantis runatlantis/atlantis -f values.yaml