output "fileUrl" {
  value = {
    Ссылка_на_файл = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-image.bucket}/${yandex_storage_object.picture.key}"
  }
}

output "Имена_VM_в_группе" {
  description = "Список имен виртуальных машин в группе."
  value       = data.yandex_compute_instance_group.group-info.instances[*].name
}

# Вывод списка внутренних IP-адресов
output "Внутренние_Ip_адреса_VM_в_группе" {
  description = "Внутренние Ip адреса VM в группе"
  value = data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].ip_address
}

# Вывод списка внутренних IP-адресов
output "Внешние_Ip_адреса_VM_в_группе" {
  description = "Внешние Ip адреса VM в группе."
  value = data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].nat_ip_address
}

