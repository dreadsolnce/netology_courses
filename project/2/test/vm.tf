# # --- 5. Создание группы экземпляров ---
# resource "yandex_compute_instance_group" "group-vm" {
#   name               = "instance-group"
#   folder_id          = var.folder_id
#
#   # Политика масштабирования: фиксированное количество ВМ
#   scale_policy {
#     fixed_scale {
#       size = var.countVM                # <-- Здесь задается количество ВМ
#     }
#   }
#
#   instance_template {
#     platform_id = var.platformVM # Современная платформа
#     resources {
#      cores                 = var.resourcesVM.cores
#       memory                = var.resourcesVM.memory
#       core_fraction         = var.resourcesVM.core_fraction
#     }
#
#     boot_disk {
#     initialize_params {
#       image_id = var.imageID
#     }
#   }
#   }
# }
#
# variable "countVM" {
#   type        = number
#   default     = 3
#   description = "Количество экземпляров vm для группы"
# }
#
# variable "platformVM" {
#   type            = string
#   default         = "standard-v3"
#   description     = "Тип создаваемой виртуальной машины"
# }
#
# variable "resourcesVM" {
#   type = object(
#     {
#       cores           = number
#       memory          = number
#       core_fraction   = number
#     }
#   )
#   default = {
#     cores             = 2
#     memory            = 1
#     core_fraction     = 20
#   }
#   description = "Ресурсы для создания виртуальных машин (одинаковые для всех машин)"
# }
#
# variable "imageID" {
#   type            = string
#   default         = "fd827b91d99psvq5fjit"
#   description     = "Образ операционной системы для NAT"
# }