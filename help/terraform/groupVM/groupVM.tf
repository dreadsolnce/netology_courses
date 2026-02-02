# Создание группы экземпляров ---
resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = var.subnets

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [each.value.cidr]
  # route_table_id = each.value.name == "private" ? yandex_vpc_route_table.rt.id : null
}

resource "yandex_iam_service_account" "service_account" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для группы ВМ"
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = var.service_account_name
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "sa_vpc_admin" {
  folder_id = var.folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.service_account.id}"
}


resource "yandex_compute_instance_group" "group-vm" {
  name               = "group-vm"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.service_account.id

  # Политика масштабирования: фиксированное количество ВМ
  scale_policy {
    fixed_scale {
      size = 3 # <-- Здесь задается количество ВМ
    }
  }

  # Политика развертывания: как обновлять экземпляры
  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  allocation_policy {
    zones = [var.instance_zone]
  }

  instance_template {
    platform_id = var.platformVM

    resources {
      cores         = var.resourcesVM.cores
      memory        = var.resourcesVM.memory
      core_fraction = var.resourcesVM.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = var.imageIDVMTemplate
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc-netology.id
      subnet_ids = [yandex_vpc_subnet.subnet["public"].id]
    }

  }
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_member.sa_vpc_admin
  ]
}

variable "folder_id" {
  type = string
  default = "b1gdmpusv51ippn2psip"
}

variable "cloud_id" {
  type = string
  default = "b1gr160bk1vuruuer3om"
}

variable "service_account_name" {
  type = string
  default = "admin"
  description = "Имя сервисного аккаунта"
}

variable "instance_zone" {
  description = "The zone to create the resources in"
  type        = string
  default     = "ru-central1-a"
}

variable "platformVM" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
}

variable "imageIDVMTemplate" {
  type            = string
  default         = "fd827b91d99psvq5fjit"
  description     = "Образ операционной системы для NAT"
}

variable "vpc_name" {
  type        = string
  default     = "netology_vpc"
  description = "Название сети"
}

variable "subnets" {
  description = "Перечень подсетей где ключ имя подсети, значение словарь"
  type = map(object({
    name = string
    zone = string
    cidr = string
  }))
  default = {
    "public" = {
      name = "public"
      zone = "ru-central1-a",
      cidr = "192.168.10.0/24"
    }
    "private" = {
      name = "private"
      zone = "ru-central1-b",
      cidr = "192.168.20.0/24"
    }
  }
}

variable "resourcesVM" {
  type = object(
    {
      cores           = number
      memory          = number
      core_fraction   = number
    }
  )
  default = {
    cores             = 2
    memory            = 1
    core_fraction     = 20
  }
  description = "Ресурсы для создания виртуальных машин (одинаковые для всех машин)"
}

#   # Политика масштабирования: фиксированное количество ВМ
#   scale_policy {
#     fixed_scale {
#       size = 3 # <-- Здесь задается количество ВМ
#     }
#   }
#
#   # Политика развертывания: как обновлять экземпляры
#   deploy_policy {
#     max_unavailable = 1
#     max_creating    = 1
#     max_expansion   = 1
#     max_deleting    = 1
#   }
#
#   instance_template {
#     platform_id = var.platformVM # Современная платформа
#
#     resources {
#       cores         = var.resourcesVM.cores
#       memory        = var.resourcesVM.memory
#       core_fraction = var.resourcesVM.core_fraction
#     }
#
#     boot_disk {
#       initialize_params {
#         image_id = var.imageIDVMTemplate
#       }
#     }
#
#     network_interface {
#       network_id = yandex_vpc_network.vpc-netology.id
#       subnet_ids = [yandex_vpc_subnet.subnet["public"].id]
#     }
#   }
#   # Политика размещения: все ВМ в одной зоне
#   allocation_policy {
#     zones = [var.instance_zone]
#   }
#
# }
