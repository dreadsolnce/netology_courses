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

variable "subnets-private" {
  description = "Перечень приватных подсетей где ключ имя подсети, значение словарь"
  type = map(object({
    name = string
    zone = string
    cidr = list(string)
    description = string
  }))
  default = {
    "private-1" = {
      name = "private-1"
      zone = "ru-central1-a"
      cidr = ["192.168.110.0/24"]
      description  = "Приватная подсеть"
    },
    "private-2" = {
      name = "private-2"
      zone = "ru-central1-b"
      cidr = ["192.168.120.0/24"]
      description  = "Приватная подсеть"
    }
  }
}

variable "subnets-public" {
  description = "Перечень публичных подсетей где ключ имя подсети, значение словарь"
  type = map(object({
    name        = string
    zone        = string
    cidr = list(string)
    description = string
  }))
  default = {
    "public-1" = {
      name        = "public-1"
      zone        = "ru-central1-a"
      cidr = ["192.168.10.0/24"]
      description = "Публичная подсеть"
    }
    "public-2" = {
      name        = "public-2"
      zone        = "ru-central1-b"
      cidr = ["192.168.20.0/24"]
      description = "Публичная подсеть"
    }
    "public-3" = {
      name        = "public-3"
      zone        = "ru-central1-d"
      cidr = ["192.168.30.0/24"]
      description = "Публичная подсеть"
    }
  }
}

variable "public-zone-ip" {
  type        = string
  default     = "ru-central1-a"
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
      subnet      = "public-1"
      ipaddress   = "192.168.10.11"
    },
    "back" = {
      nat         = false
      zone        = "ru-central1-b"
      subnet      = "private-1"
      ipaddress   = "192.168.110.12"
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
    subnet      = "public-1"
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
  default   = "public-read" # ["bucket-owner-full-control" "public-read" "public-read-write" "authenticated-read" "private"]
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

variable "service_account_role" {
  type = object({
    role_admin      = string
    role_vpc        = string
    role_kms        = string
    role_k8s        = string
    role_container  = string
    role_cluster    = string
    role_balancer   = string
    description     = string
  })
  default = {
    role_admin      = "compute.admin"
    role_vpc        = "vpc.admin"
    role_kms        = "kms.keys.encrypterDecrypter"
    role_k8s        = "k8s.admin"
    role_container  = "container-registry.images.puller"
    role_cluster    = "k8s.clusters.agent"
    role_balancer   = "load-balancer.admin"
    description     = "Необходимые роли сервисного аккаунта"
  }
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

######################### Переменные KMS ###############################################
variable "kms_key" {
  type = object({
    name      = string
    algorithm = string
    period    = string
    protect   = bool
  })
  default = {
    name      = "my-key"
    algorithm = "AES_256"
    period    = "8760h"
    protect = false
  }
}

####################### Переменные Базы данных MySql #############################################
variable "cluster_mysql" {
  description = "Переменные для кластера MySQL базы данных"
  type          = object({
    name        = string
    type        = string
    version     = string
    maintenance = string
    backup = object({
      minute =  number
      hours = number
    })
    protection  = bool
  })
  default = {
    name = "cluster-mysql"
    type = "PRESTABLE"
    version    = "8.4"
    maintenance = "ANYTIME"
    backup = {
      hours = 23
      minute = 59
    }
    protection  = false
  }
}

variable "cluster_mysql_resources" {
  description = "Ресурсы для vm кластера"
  type = object({
    resource_preset_id = string
    disk_type_id       = string
    disk_size          = number
  })
  default = {
    resource_preset_id  = "b1.medium"
    disk_type_id        = "network-hdd"
    disk_size           = 20
  }
}

variable "database" {
  type = object({
    name      = string
    user      = string
    roles     = list(string)
  })
  default = {
    name      = "netology_db"
    user      = "test"
    roles     = ["ALL"]
  }
}

variable "password_database" {
  type = string
  description = "Пароль от базы данных"
}

####################### Переменные кластера k8s #############################################
variable "cluster_k8s_name" {
  type = string
  default = "k8s-cluster"
  description = "Имя кластера"
}

variable "cluster_k8s_group_name" {
  type = string
  default = "worker-node"
  description = "Имя для группы node"
}

variable "cluster_k8s_node" {
  type = object({
    type  = string
    size  = number
    subnet_name  = string
  })
  default = {
    type  = "network-hdd"
    size  = 30
    subnet_name  = "private-1"

  }
  description = "Конфигурация для рабочих нод кластера"
}