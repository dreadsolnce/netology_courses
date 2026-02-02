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

######################### переменные vm ###############################################
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

variable "platformVM" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
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

variable "settingsVM" {
  description = "Перечень настроек для vm, где public - использовать ли NAT"
  type = map(object({
    nat         = bool
    zone        = string
    subnet      = string
    ipaddress   = string
  }))
  default = {
    "front" = {
      nat         = true
      zone        = "ru-central1-a"
      subnet      = "public"
      ipaddress   = "192.168.10.11"
    },
    "back" = {
      nat         = false
      zone        = "ru-central1-b"
      subnet      = "private"
      ipaddress   = "192.168.20.12"
    }
  }
}

variable "settingsVmNAT" {
  description = "Перечень настроек для vm nat"
  type = object({
    nat         = bool
    name      = string
    zone      = string
    subnet    = string
    ipaddress = string
  })
  default = {
    name        = "nat"
    zone        = "ru-central1-a"
    subnet      = "public"
    ipaddress   = "192.168.10.254"
    nat         = true
  }
}
