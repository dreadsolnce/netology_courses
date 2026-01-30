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
# variable "natIP" {
#   type        = string
#   default     = "192.168.10.254"
#   description = "ip адрес NAT instance"
# }

# ######################## переменные vm ##############################################
variable "imageVM" {
  type            = string
  default         = "ubuntu-2204-lts"
  description     = "Образ операционной системы для NAT"
}

variable "imageNAT" {
  type            = string
  default         = "fd80mrhj8fl2oe87o4e1"
  description     = "Образ операционной системы для NAT"
}

variable "type-vm" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
}

variable "settingsVM" {
  type = list(object(
    {
      vmNAME   = string,
      typeNAT   = bool,
      zoneVM    = string,
      ipaddress = string
    }
  ))
  default = [
    {
      vmNAME = "front"
      typeNAT = true
      zoneVM = "ru-central1-a"
      ipaddress = "192.168.10.11"
    },
    {
      vmNAME = "back"
      typeNAT = false
      zoneVM = "ru-central1-b"
      ipaddress = "192.168.20.12"
    },
    {
      vmNAME    = "nat"
      typeNAT   = true
      zoneVM    = "ru-central1-a"
      ipaddress = "192.168.10.254"
    }
  ]
  description = "Индивидуальные настройки для vm"
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
