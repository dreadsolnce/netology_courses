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

######################### переменные VM и NAT ###############################################
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
      nat         = false
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

######################### переменные для object storage ###############################################

variable "name_db" {
  type        = string
  default     = "db-images"
  description = "Имя базы данных"
}

variable "bucket_name" {
  type        = string
  default     = "kolchinvl20260202"
  description = "Бакет для хранения картинок"
}

variable "bucket_acl" {
  type      = string
  default   = "public"
  description = "Режим доступа к бакету"
}

variable "bucket_image" {
  type        = string
  default     = "cat.jpg"
  description = "Имя файла, которое он получит в бакете"
}

variable "bucket_image_path" {
  type        = string
  default     = "cat.jpg"
  description = "Путь к локальному файлу, который нужно загрузить"
}

######################### Переменные для группы VM ###############################################
variable "group_vm_name" {
  type        = string
  default     = "group-vm"
  description = "Имя группы VM"
}

variable "group_vm_count" {
  type        = number
  default     = 3
  description = "Количество VM в группе по умолчанию"
}

variable "group_policy" {
  type = object({
    max_unavailable = number
    max_creating    = number
    max_expansion   = number
    max_deleting    = number
  })
  default = {
    max_unavailable = 2
    max_creating    = 3
    max_expansion   = 4
    max_deleting    = 1
  }
  description = "развертывания VM "
}

variable "group_vm_net" {
  type        = bool
  default     = false
  description = "Использовать ли NAT"
}

variable "group_image_id" {
  type            = string
  default         = "fd827b91d99psvq5fjit"
  description     = "Образ операционной системы для NAT"
}

variable "group_zone" {
  description = "Политика размещения ресурсов (ВМ)"
  type        = string
  default     = "ru-central1-a"
}

variable "group_health_check" {
  type = object({
    interval              = number
    timeout               = number
    unhealthy_threshold   = number
    healthy_threshold     = number
    healthy_port          = number
  })
  default = {
    interval              = 15
    timeout               = 10
    unhealthy_threshold   = 3
    healthy_threshold     = 2
    healthy_port          = 80
  }
  description = "Проерка доступности VM "
}

######################### Переменные для сервисного аккаунта ###############################################
variable "service_account_name" {
  type = string
  default = "devops"
  description = "Имя сервисного аккаунта"
}

variable "role_sa" {
  type = string
  default = "compute.admin"
  description = "Роль editor для создаваемого сервисного аккаунта"
}

variable "role_sa_vpc" {
  type        = string
  default   = "vpc.admin"
  # default     = "resource-manager.admin"
  description = "Роль редактор сети для создаваемого сервисного аккаунта"
}

######################### Переменные для сетевого балансировщика ###############################################
variable "lb_name" {
  type        = string
  default     = "network-balancer"
  description = "Имя сетевого балансировщика"
}

######################### Переменные для applications балансировщика ###############################################
variable "alb" {
  type = map(object({
    name_tg           = string
    name_bg           = string
    name_route_http   = string
    prefix            = string
    prefix_rewrite    = string
  }))
  default = {
    "front" = {
      name_tg             = "front"
      name_bg             = "front"
      name_route_http     = "front"
      prefix              = "/web"
      prefix_rewrite      = "/"
    }
    "back" = {
      name_tg             = "back"
      name_bg             = "back"
      name_route_http     = "back"
      prefix              = "/back"
      prefix_rewrite      = "/"
    }
  }
  description = "Перечень настроек для виртуальных машин из первого задания"
}

variable "group_backend" {
  type = object({
    name            = string
    port            = number
    health_timeout  = string
    health_interval = string
  })
  default = {
    name            = "backend"
    port            = 80
    health_timeout  =  "1s"
    health_interval = "2s"
  }
}

variable "name_router" {
  type = string
  default = "production"
}

variable "name_virualhost" {
  type = string
  default = "site"
}

variable "name_balancer" {
  type = string
  default = "alb"
}

variable "name_listen" {
  type = string
  default = "http"
}

variable "port_listen" {
  type = list(number)
  default = [80]
}

variable "packages" {
    type        = list(string)
    default     = [ "nginx"]
    description = "Устанавливаемые пакеты по умолчанию"
}