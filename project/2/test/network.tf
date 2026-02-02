resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Публичная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_public" {
  name           = var.subnets["public"].name
  zone           = var.subnets["public"].zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.subnets["public"].cidr]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_private" {
  name           = var.subnets["private"].name
  zone           = var.subnets["private"].zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.subnets["private"].cidr]
  # route_table_id = yandex_vpc_route_table.rt.id
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
