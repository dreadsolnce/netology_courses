# # Создание группы узлов (Node Group) для кластера с 3 нодами
# resource "yandex_kubernetes_node_group" "my_k8s_node_group_3_nodes" {
#   cluster_id  = yandex_kubernetes_cluster.k8s_cluster.id
#   name        = var.cluster_k8s_group_name
#   description = "Группа из трех рабочих узлов"
#
#   instance_template {
#     platform_id = var.platformVM
#
#     resources {
#       cores         = var.resourcesVM.cores
#       memory        = var.resourcesVM.memory
#       core_fraction = var.resourcesVM.core_fraction
#     }
#     boot_disk {
#       type = var.cluster_k8s_node.type
#       size = var.cluster_k8s_node.size
#     }
#
#     network_interface {
#       nat        = false
#       # ОБЯЗАТЕЛЬНЫЙ ПАРАМЕТР:
#       subnet_ids = [yandex_vpc_subnet.subnet-private[var.cluster_k8s_node.subnet_name].id]
#       security_group_ids = [yandex_vpc_security_group.sg-private.id]
#     }
#
#     metadata = {
#       serial-port-enable = 1
#       ssh-keys           = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
#     }
#   }
#
#   scale_policy {
#     auto_scale {
#       min     = 3
#       max     = 6
#       initial = 3
#     }
#   }
#
#   allocation_policy {
#     location {
#       zone = var.subnets-private[var.cluster_k8s_node.subnet_name].zone
#     }
#   }
#
#   depends_on = [
#     yandex_iam_service_account.service-account,
#     yandex_kubernetes_cluster.k8s_cluster
#   ]
# }