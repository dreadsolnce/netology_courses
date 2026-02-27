# До настройка кластера
mkdir .kube
sudo cp /etc/kubernetes/admin.conf .kube/config
sudo chown -R $(whoami):$(whoami) .kube/

kubectl taint nodes master1 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint nodes master2 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint nodes master3 node-role.kubernetes.io/control-plane:NoSchedule-

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

# Отключаем правило которое блокирует внешние подключения
kubectl -n monitoring delete networkpolicies.networking.k8s.io grafana

