# Вывод созданных подсетей
output "созданные_подсети" {
  description = "Созданные подсети"
  value = {
    public_subnets = [
      for k, v in yandex_vpc_subnet.subnet-public : {
        name = v.name
        cidr = v.v4_cidr_blocks
        zone = v.zone
      }
    ]
    private_subnets = [
      for k, v in yandex_vpc_subnet.subnet-private : {
        name  = v.name
        cidr  = v.v4_cidr_blocks
        zone  = v.zone
      }
    ]
  }
}

output "внешний_ip_адресс_кластера_k8s" {
  value = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_address
}

output "fqdn_имя_кластера_MySQL" {
  value = yandex_mdb_mysql_cluster.mysql-cluster.host[*].fqdn
}
# output "fileUrl" {
#   value = {
#     Ссылка_на_файл = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-image.bucket}/${yandex_storage_object.picture.key}"
#   }
# }
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

