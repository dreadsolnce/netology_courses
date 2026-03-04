# До настройка кластера

# Нужен для того чтобы скрипт немедленно завершился в случае ошибки на каком либо этапе
set -e

cd /tmp

# установка grafana
git clone https://github.com/prometheus-operator/kube-prometheus.git

cd kube-prometheus

kubectl apply --server-side -f manifests/setup

kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring

kubectl apply -f manifests/

kubectl get pods -n monitoring

# Для простоты отключаем правило которое блокирует внешние подключения
kubectl -n monitoring delete networkpolicies.networking.k8s.io grafana

kubectl -n monitoring apply -f /tmp/grafana-node-port.yml
