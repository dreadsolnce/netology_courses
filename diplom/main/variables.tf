#cloud vars
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
    "public" = {
      zone         = "ru-central1-a"
      cidr         = "192.168.4.0/24"
    }
  }
  description = "Используемые подсети в проекте"
}

######################## переменные для vm bastion #######################################################
variable "image_bastion" {
  type            = string
  # default         = "fd80mrhj8fl2oe87o4e1"
  default         = "fd8g9ua2q01c2qvigpmb"
  description     = "Образ операционной системы для BASTION"
}

variable "resources_bastion" {
  type = object(
    {
      cores           = number
      memory          = number
      core_fraction   = number
      disk_size       = number
    }
  )
  default = {
    cores             = 2
    memory            = 4
    core_fraction     = 50
    disk_size         = 15
  }
  description = "Ресурсы для vm бастион"
}

variable "settings_bastion" {
  description = "Перечень настроек для vm nat"
  type = object({
    hostname    = string
    zone        = string
    # subnet      = string
    ipaddress   = string
    nat         = bool
  })
  default = {
    hostname        = "bastion"
    zone            = "ru-central1-a"
    # subnet      = "public"
    ipaddress       = "192.168.4.144"
    nat             = true
  }
}

#####################Переменные cloud-init##################################
variable "packages" {
    type        = list(string)
    default     = [ "htop", "tmux", "net-tools", "mc", "vim", "nginx", "ansible", "git", "python3-venv", "libssl-dev", "liblzma-dev", "python3-tk", "libsqlite3-dev", "libreadline-dev", "libffi-dev", "libncurses5-dev", "libncursesw5-dev", "libbz2-dev", "build-essential", "gcc", "python3-pip", "mysql-client" ]
    description = "Устанавливаемые пакеты по умолчанию"
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
      disk_size       = number
    }
  )
  default = {
    cores             = 2
    memory            = 4
    core_fraction     = 100
    disk_size         = 15
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
      nat         = false
      zone        = "ru-central1-a"
      ipaddress   = "192.168.1.11"
    },
    "master2" = {
      nat         = false
      zone        = "ru-central1-b"
      ipaddress   = "192.168.2.22"
    }
    "master3" = {
      nat         = false
      zone        = "ru-central1-d"
      ipaddress   = "192.168.3.33"
    }
  }
}
