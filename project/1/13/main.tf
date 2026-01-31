resource "yandex_vpc_network" "_vpc_" {
  name = var.vpcName == null ? "unknown" : var.vpcName
}

# Публичная подсеть
resource "yandex_vpc_subnet" "_vpc_subnet_public_" {
  name           = keys(var.subNets)[1]
  zone           = var.subNets[keys(var.subNets)[1]].zone
  network_id     = yandex_vpc_network._vpc_.id
  v4_cidr_blocks = [var.subNets[keys(var.subNets)[1]].cidr]
}
#
# # Приватная подсеть
# resource "yandex_vpc_subnet" "_vpc_subnet_private_" {
#   name           = var.vpc_subnet_name[1]
#   zone           = var.zone[1]
#   network_id     = yandex_vpc_network._vpc_.id
#   v4_cidr_blocks = [var.cidr[1]]
#   # route_table_id = yandex_vpc_route_table.rt.id
# }

output "outVPC" {
  value = yandex_vpc_network._vpc_.name
}

output "outSubnets" {
  value = keys(var.subNets)
}

output "outSubnetsZonePublic" {
  value = var.subNets["public"].zone
}

variable "vpcName" {
  type        = string
  default     = "netology_vpc"
  description = "Название сети"
}

variable "subNets" {
  description = "Перечень подсетей где ключ имя подсети, значение словарь"
  type = map(object({
    zone = string
    cidr = string
  }))
  default = {
    "public" = {
      zone = "ru-central1-a",
      cidr = "192.168.10.0/24"
    }
    "private" = {
      zone = "ru-central1-b",
      cidr = "192.168.20.0/24"
    }
  }
}
