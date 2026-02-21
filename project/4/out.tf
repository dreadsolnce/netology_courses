# Вывод имени сети
output "имя_сети" {
  value = yandex_vpc_network.vpc.name
}

# Вывод подсетей
output "созданные_подсети" {
  value = [
    for item in local.flattened_subnets: item.name
  ]
}

# Вывод информации о созданных виртуальных машинах
output "имена_виртуальных_машин" {
  description = "Список имен созданных виртуальных машин."
  value = [
    for item in yandex_compute_instance.app-web-back: item.name
  ]
}

output "внешний_ip_адресс_кластера_k8s" {
  value = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_address
}

output "fqdn_имя_кластера_MySQL" {
  value = yandex_mdb_mysql_cluster.mysql-cluster.host[*].fqdn
}
output "fileUrl" {
  value = {
    Ссылка_на_файл = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-image.bucket}/${yandex_storage_object.picture.key}"
  }
}
#
# output "Имена_VM_в_группе" {
#   description = "Список имен виртуальных машин в группе."
#   value       = data.yandex_compute_instance_group.group-info.instances[*].name
# }
#
# # Вывод списка внутренних IP-адресов
# output "Внутренние_Ip_адреса_VM_в_группе" {
#   description = "Внутренние Ip адреса VM в группе"
#   value = data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].ip_address
# }
#
# # Вывод списка внутренних IP-адресов
# output "Внешние_Ip_адреса_VM_в_группе" {
#   description = "Внешние Ip адреса VM в группе."
#   value = data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].nat_ip_address
# }

