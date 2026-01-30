###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

######################## переменные сети ##############################################

variable "vpc_name" {
  type        = string
  default     = "netology_vpc"
  description = "Название сети"
}

variable "zone" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b"]
  description = "Используемая зона"
}

variable "vpc_subnet_name" {
  type        = list(string)
  default     = ["public", "private"]
  description = "Название подсетей для vm"
}

variable "cidr" {
    type          = list(string)
    default       = ["192.168.10.0/24", "192.168.20.0/24"]
    description   = "Диапазон ip адресов для публичной и приватной подсети"
}

# ######################## переменные nat ##############################################
# variable "platform_id" {
#   type        = string
#   default     = "standard-v3"
#   description = "тип конфигурации NAT instance"
# }
#
# variable "name_instance_nat" {
#   type        = string
#   default     = "nat"
#   description = "Название NAT instance"
# }
#
# variable "nat_ip" {
#   type        = string
#   default     = "192.168.10.254"
#   description = "ip адрес NAT instance"
# }
#
# variable "nat_core" {
#   type = number
#   default = 2
#   description = "Number of virtual processors"
# }
#
# variable "nat_memory" {
#   type = number
#   default = 1
#   description = "Amount of memory"
# }
#
# variable "nat_core_fraction" {
#   type = number
#   default = 20
#   description = "CPU Power Ratio"
# }
#
# ######################## переменные vm1 ##############################################
variable "image-vm-family" {
  type            = string
  default         = "ubuntu-2204-lts"
  description     = "Образ операционной системы используемой в vm"
}

variable "type-vm" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
}

variable "name-vm" {
  type            = list(string)
  default         = ["vm-public","vm-private","vm-nat"]
  description     = "Имена виртуальных машин"
}

variable "resourcesVM" {
  type = object(
    {
      cores = number
      memory: number
      core_fraction: number
    }
  )
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
  description = "Ресурсы для создания первых двух машин"
}
#
# ######################## переменные vm2 ##############################################
# variable "name-vm2" {
#   type            = string
#   default         = "vm2"
#   description     = "Имя виртуальной машины и ее hostname"
# }
