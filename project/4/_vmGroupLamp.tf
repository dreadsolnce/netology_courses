# # Создание группы экземпляров ---
#
# resource "yandex_compute_instance_group" "group-vm-lamp" {
#   depends_on = [
#     yandex_iam_service_account.service-account,
#     yandex_vpc_network.vpc,
#     yandex_vpc_subnet.subnet
#   ]
#
#   name      = var.group_vm_name
#   folder_id = var.folder_id
#   service_account_id = yandex_iam_service_account.service-account.id
#   deletion_protection = false
#
#   # Политика масштабирования: фиксированное количество ВМ
#   scale_policy {
#     fixed_scale {
#       size = var.group_vm_count # <-- Здесь задается количество ВМ
#     }
#   }
#
#   # Политика развертывания: как обновлять экземпляры
#   deploy_policy {
#     max_unavailable = var.group_policy.max_unavailable
#     max_creating    = var.group_policy.max_creating
#     max_expansion   = var.group_policy.max_expansion
#     max_deleting    = var.group_policy.max_deleting
#   }
#
#   instance_template {
#     platform_id = var.platform_vm
#
#     resources {
#       cores         = var.resources_vm.cores
#       memory        = var.resources_vm.memory
#       core_fraction = var.resources_vm.core_fraction
#     }
#
#     boot_disk {
#       initialize_params {
#         image_id = var.group_image_id
#       }
#     }
#
#     network_interface {
#       network_id  = yandex_vpc_network.vpc.id
#       # security_group_ids     = [yandex_vpc_security_group.sg-public.id]
#       subnet_ids = [yandex_vpc_subnet.subnet[var.group_vm_lamp_subnet].id]
#       nat         = var.group_vm_net
#     }
#
#     metadata = {
#       serial-port-enable = 1
#       # Через файл открытого ключа pub на локальной машине
#       ssh-keys           = "ubuntu:${local.ssh_pub_key}"
#       # Установка дополнительного ПО
#       user-data          = data.template_file.cloudinit-lamp.rendered
#     }
#   }
#   # Политика размещения: все ВМ в одной зоне
#   allocation_policy {
#     zones = [var.group_zone]
#   }
#
#   # Проверка доступности виртуальных машин
#   health_check {
#     interval              = var.group_health_check.interval                  // Проверять каждые 15 секунд
#     timeout               = var.group_health_check.timeout                   // Таймаут 10 секунд
#     unhealthy_threshold   = var.group_health_check.healthy_threshold         // 3 неудачных проверки подряд -> unhealthy
#     healthy_threshold     = var.group_health_check.healthy_threshold         // 2 успешных проверки подряд -> healthy
#
#     tcp_options {
#       port                = var.group_health_check.healthy_port              // Проверять TCP соединение на порту 80 (http)
#     }
#   }
# }
#
# data "template_file" "cloudinit-lamp" {
#   template = file("./cloud-init-lamp.yml")
#   vars = {
#     ssh_public_key = local.ssh_pub_key
#     url_for_jpg = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket-image.bucket}/${yandex_storage_object.picture.key}"
#   }
# }
#
# # data "yandex_compute_instance_group" "group-info" {
# #   # Указываем ID группы, инстансы которой мы хотим получить
# #   instance_group_id = yandex_compute_instance_group.group-vm.id
# #
# #   depends_on = [
# #     yandex_compute_instance_group.group-vm
# #   ]
# # }
