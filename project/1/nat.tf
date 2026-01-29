# # NAT-инстанс
#     resource "yandex_compute_instance" "nat_instance" {
#       name        = var.name_instance_nat
#       platform_id = var.platform_id
#       zone        = var.zone
#
#       allow_stopping_for_update = true
#
#       resources {
#         cores         = var.nat_core
#         memory        = var.nat_memory
#         core_fraction = var.nat_core_fraction
#       }
#
#       boot_disk {
#         initialize_params {
#           # Готовый образ с настроенным NAT
#           image_id = "fd80mrhj8fl2oe87o4e1"
#         }
#       }
#
#       network_interface {
#         subnet_id      = yandex_vpc_subnet.vpc_subnet.id
#         nat            = true
#         ip_address     = var.nat_ip # Рекомендуется статический
#         # security_group_ids = [yandex_vpc_security_group.nat_sg.id]
#       }
#
#       metadata = {
#       user-data = "#!/bin/bash\nsudo sysctl -w net.ipv4.ip_forward=1"
#    }
# }
