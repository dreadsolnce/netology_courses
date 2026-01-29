# # Создание виртуальной машины
# #---------------------------------------------------------------------
# data "yandex_compute_image" "image-vm2" {
#   family = var.image-vm-family
# }
#
# resource "yandex_compute_instance" "vm2" {
#   # name        = join("", [var.nameVMWeb, "-${count.index+1}"])
#   name        = var.name-vm2
#   zone        = var.zone
#   platform_id = var.type-vm
#   hostname    = var.name-vm2
#   # service_account_id = yandex_iam_service_account.docker.id
#
#   resources {
#     cores         = var.resourcesVM.cores
#     memory        = var.resourcesVM.memory
#     core_fraction = var.resourcesVM.core_fraction
#   }
#
#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.image-vm.image_id
#     }
#   }
#
#   network_interface {
#     subnet_id = yandex_vpc_subnet.vpc_subnet_private.id
#     # security_group_ids = [yandex_vpc_security_group.security_group_production.id]
#     # nat = true
#   }
#
#   metadata = {
#     serial-port-enable = 1
#     # Через файл открытого ключа pub на локальной машине
#     ssh-keys = "ubuntu:${local.ssh_pub_key}"
#   }
# }