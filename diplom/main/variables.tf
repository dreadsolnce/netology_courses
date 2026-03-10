##cloud vars
variable "yc_cloud_id" {
  type        = string
  # default     = "b1gr160bk1vuruuer3om"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "yc_folder_id" {
  type        = string
  # default     = "b1gdmpusv51ippn2psip"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default-zone" {
  type      = string
  default   = "ru-central1-a"
  description = "Зона доступности по умолчанию"
}

variable "auth_key_sa_yandex" {
  type        = string
  # default     = "~/keys/authorized-key-diplom.json"
  description = "Имя файла с ключами для работы с ресурсами в yandex облаке"
}

variable "auth_key_s3" {
  type        = string
  # default     = "~/.aws/credentials-diplom"
  description = "Имя файла с ключами для доступа к бакету s3"
}

variable "ssh_public_key" {
  type        = string
  # default     = "~/.ssh/id_rsa.pub"
  description = "Путь у файлу с открытым ключом для доступа к vm с локальной машины "
}


# variable "name_location" {
#   type      = string
#   default   = "ru-central1"
#   description = "Географический регион"
# }

# ######################## переменные сети ##############################################
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
      cidr         = "192.168.1.0/28"
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
#
# ######################## переменные для vm bastion #######################################################
variable "image_bastion" {
  type            = string
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
      type_disk       = string
    }
  )
  default = {
    cores             = 2
    memory            = 4
    core_fraction     = 50
    disk_size         = 15
    type_disk         = "network-hdd"
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
    default     = [ "htop", "tmux", "net-tools", "mc", "vim", "nginx", "ansible", "git", "python3-venv", "libssl-dev", "liblzma-dev", "python3-tk", "libsqlite3-dev", "libreadline-dev", "libffi-dev", "libncurses5-dev", "libncursesw5-dev", "libbz2-dev", "build-essential", "gcc", "python3-pip" ] #, "mysql-client" ]
    description = "Устанавливаемые пакеты по умолчанию"
}

variable "db_host" {
  type            = string
  # default         = "test"
  description     = "Переменная с именем хоста базы данных"
}

variable "db_user" {
  type        = string
  # default     = "test"
  description = "Переменная с именем пользователя базы данных"
}

variable "db_password" {
  type        = string
  # default     = "test"
  description = "Переменная с паролем пользователя базы данных"
}

variable "db_name" {
  type        = string
  # default     = "test"
  description = "Переменная с именем базы данных"
}

variable "mysql_root_password" {
  type        = string
  # default     = "test"
  description = "Переменная с паролем пользователя root базы данных"
}
# atlantis
variable "secret" {
  type        = string
  # default     = "test"
  description = "Секретная фраза для webhook github"
}

variable "token" {
  type        = string
  # default     = "ghp_test"
  description = "Переменная с токеном для доступа к github репозиторию"
}

variable "url" {
  type        = string
  # default     = "atlantis.kvlpro.site"
  description = "Доменное имя сервиса atlantis"
}

variable "username" {
  type        = string
  # default     = "dreadsolnce"
  description = "Имя пользователя для доступа к github репозиторию"
}

variable "repo_github" {
  type        = string
  # default     = "dreadsolnce"
  description = "GitHub репозиторий"
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
      type_disk       = string
    }
  )
  default = {
    cores             = 2
    memory            = 4
    core_fraction     = 100
    disk_size         = 15
    type_disk         = "network-hdd"
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
