###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

# ######################## Переменные сети ##############################################
variable "vpc_name" {
  type        = string
  default     = "mynet"
  description = "Название сети"
}

variable "vpc_name_subnet" {
  type        = string
  default     = "mynet-subnet"
  description = "Название подсети в сети my-net"
}

variable "zone" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central-b"]
  description = "Используемая зона"
}

variable "cidr" {
    type          = list(string)
    default       = ["10.0.0.0/24", "10.0.1.0/24"]
    description   = "Диапазон ip адресов подсети"
}

# ######################## переменные firewall сети ##############################################

# Правила входящих соединений
variable "sec_group_mynet_in" {
  description = "правила для входящих соединений"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий ssh"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий  http"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 2377
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 7946
    },
    {
      protocol       = "UDP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 7946
    },
    {
      protocol       = "UDP"
      description    = "разрешить входящий https"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 4789
    },
  ]
}

# Правила исходящих соединений
variable "sec_group_mynet_out" {
  description = "правила для входящих соединений"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}

# ######################## переменные виртуальных машин ##############################################

# id образа операционной системы на которой будет разворачиваться виртуальная машина
variable "imageID" {
  type        = string
  default     = "fd8d464f5srt40f0mftt"
  description = "id образа виртуальной машины"
}

# Стандартная конфигурация виртуальных машин
variable "platformID" {
  type        = string
  default     = "standard-v3"
  description = "стандартная конфигурация виртуальных машин"
}

# Общее имя в названии виртуальных машин
variable "nameVM" {
  type        = string
  default     = "node"
  description = "Основная часть имени виртуальной машины"
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


# ######################## переменные виртуальной машины ####################################
# variable "path-app" {
#   type        = string
#   default     = "/home/ubuntu/app-animals"
#   description = "Путь где располагается web приложение в виртуальной машине"
# }
#
# variable "image-vm-family" {
#   type            = string
#   default         = "ubuntu-2204-lts"
#   description     = "Образ операционной системы используемой в vm"
# }
#
# variable "name-vm" {
#   type            = string
#   default         = "web"
#   description     = "Имя виртуальной машины и ее hostname"
# }
#
# variable "type-vm" {
#   type            = string
#   default         = "standard-v3"
#   description     = "Тип создаваемой виртуальной машины"
# }
#
# variable "resourcesVM" {
#   type = object(
#     {
#       cores = number
#       memory: number
#       core_fraction: number
#     }
#   )
#   default = {
#     cores         = 2
#     memory        = 1
#     core_fraction = 20
#   }
#   description = "Ресурсы для создания первых двух машин"
# }
#
# #####################Переменные cloud-init##################################
#
# variable "packages" {
#     type        = list(string)
#     default     = [ "htop", "tmux", "net-tools", "mc", "vim", "mysql-client"]
#     description = "Устанавливаемые пакеты по умолчанию"
# }
#
# ####################Переменные container registry##########################
# variable "kvl-registry" {
#   type = string
#   default = "kvl-registry"
#   description = "Название registry где располагаются мои образа"
# }
#
# variable "target_folder_id" {
#   type = string
#   default = "b1gdmpusv51ippn2psip"
#   description = "идентификатор каталога для размещения ВМ"
# }
#
# variable "docker" {
#   type = string
#   default = "docker"
#   description = "имя сервисного аккаунта"
# }
#
#
# ################Переменные подключения к базе данных######################
# variable "DB_HOST" {
#   type        = string
#   description = "имя хоста с базой данных"
# }
#
# variable "DB_USER" {
#   type        = string
#   description = "Пользователь для подключения к базе данных на хосту DB_HOST"
# }
#
# variable "DB_PASSWORD" {
#   type        = string
#   description = "Пароль пользователя DB_USER"
# }
#
# variable "DB_NAME" {
#   type        = string
#   description = "Имя базы данных к которой подключается пользователь DB_USER"
# }
#
# variable "MYSQL_ROOT_PASSWORD" {
#   type        = string
#   description = ""
# }
#
# variable "MYSQL_USER" {
#   type        = string
#   description = ""
# }
#
# variable "MYSQL_PASSWORD" {
#   type        = string
#   description = ""
# }
#
# variable "MYSQL_DATABASE" {
#   type        = string
#   description = ""
# }