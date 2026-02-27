##cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "ydb_key" {
  type        = string
  default     = "credentials-diplom"
  description = "Имя файла с ключами для доступа к бакету s3"
}

variable "auth_key" {
  type        = string
  default     = "authorized-key-diplom"
  description = "Имя файла с ключами для работы с ресурсами в yandex облаке"
}

variable "name_location" {
  type      = string
  default   = "ru-central1"
  description = "Географический регион"
}

variable "default-zone" {
  type      = string
  default   = "ru-central1-a"
  description = "Зона доступности по умолчанию"
}
######################## переменные сети ##############################################
variable "vpc_name" {
  type        = string
  default     = "vpc-diplom"
  description = "Сеть для дипломной работы"
}

variable "subnets" {
  type = map(object({
    zone           = string
    cidr           = string
  }))
  default = {
    "a" = {
      zone         = "ru-central1-a"
      cidr         = "192.168.1.0/24"
    }
    "b" = {
      zone         = "ru-central1-b"
      cidr         = "192.168.2.0/24"
    }
    "d" = {
      zone         = "ru-central1-d"
      cidr         = "192.168.3.0/24"
    }
  }
  description = "Используемые подсети в проекте"
}

######################## переменные для мастер нод кластера ##############################################
variable "image" {
  type            = string
  default         = "ubuntu-2204-lts"
  description     = "Образ операционной системы"
}

variable "platform" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
}

variable "resources_master_nodes" {
  type = object(
    {
      cores           = number
      memory          = number
      core_fraction   = number
    }
  )
  default = {
    cores             = 4
    memory            = 8
    core_fraction     = 100
  }
  description = "Ресурсы для создания виртуальных машин (одинаковые для всех машин)"
}

variable "settings_master_node" {
  description = "Перечень настроек для мастер нод кластера"
  type = map(object({
    nat         = bool
    zone        = string
    ipaddress   = string
  }))
  default = {
    "master1" = {
      nat         = true
      zone        = "ru-central1-a"
      ipaddress   = "192.168.1.11"
    },
    "master2" = {
      nat         = true
      zone        = "ru-central1-b"
      ipaddress   = "192.168.2.22"
    }
    "master3" = {
      nat         = true
      zone        = "ru-central1-d"
      ipaddress   = "192.168.3.33"
    }
  }
}
