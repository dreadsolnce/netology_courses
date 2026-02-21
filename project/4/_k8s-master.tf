# Создание кластера Kubernetes

resource "yandex_kubernetes_cluster" "k8s_cluster" {
 name        = var.cluster_k8s_name
 description = "Тестовый кластер Kubernetes"
 network_id  = yandex_vpc_network.vpc.id

 master {
   dynamic master_location {
    # for_each = yandex_vpc_subnet.subnet["k8s"]
    for_each = { for k in local.flattened_subnets: k.name => k if strcontains(k.name, "k8s-public")  }
     content {
       zone = master_location.value.zone
       # subnet_id = master_location.value.id
       subnet_id = yandex_vpc_subnet.subnet[master_location.key].id
     }
   }
   public_ip = true
 }
 kms_provider {
   key_id = yandex_kms_symmetric_key.kms-key.id
 }

 service_account_id = yandex_iam_service_account.service-account.id
 node_service_account_id = yandex_iam_service_account.service-account.id

 depends_on = [
   yandex_iam_service_account.service-account,
 ]
}
