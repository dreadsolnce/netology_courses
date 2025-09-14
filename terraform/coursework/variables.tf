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
  default     = "production"
  description = "Название сети"
}

variable "vpc_subnet_name" {
  type        = string
  default     = "production-subnet"
  description = "Название сети"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Используемая зона"
}

variable "cidr" {
    type          = list(string)
    default       = ["10.0.1.0/24"]
    description   = "Диапазон ip адресов подсети"
}

######################## переменные виртуальной машины ####################################
variable "path-app" {
  type        = string
  default     = "/home/ubuntu/app-animals"
  description = "Путь где располагается web приложение в виртуальной машине"
}

variable "image-vm-family" {
  type            = string
  default         = "ubuntu-2204-lts"
  description     = "Образ операционной системы используемой в vm"
}

variable "name-vm" {
  type            = string
  default         = "web"
  description     = "Имя виртуальной машины и ее hostname"
}

variable "type-vm" {
  type            = string
  default         = "standard-v3"
  description     = "Тип создаваемой виртуальной машины"
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

#####################Переменные cloud-init##################################

variable "packages" {
    type        = list(string)
    default     = [ "htop", "tmux", "net-tools", "mc", "vim", "mysql-client"]
    description = "Устанавливаемые пакеты по умолчанию"
}

####################Переменные container registry##########################
variable "kvl-registry" {
  type = string
  default = "kvl-registry"
  description = "Название registry где располагаются мои образа"
}

variable "target_folder_id" {
  type = string
  default = "b1gdmpusv51ippn2psip"
  description = "идентификатор каталога для размещения ВМ"
}

variable "docker" {
  type = string
  default = "docker"
  description = "имя сервисного аккаунта"
}


################Переменные подключения к базе данных######################
variable "DB_HOST" {
  type        = string
  description = "имя хоста с базой данных"
}

variable "DB_USER" {
  type        = string
  description = "Пользователь для подключения к базе данных на хосту DB_HOST"
}

variable "DB_PASSWORD" {
  type        = string
  description = "Пароль пользователя DB_USER"
}

variable "DB_NAME" {
  type        = string
  description = "Имя базы данных к которой подключается пользователь DB_USER"
}

variable "MYSQL_ROOT_PASSWORD" {
  type        = string
  description = ""
}

variable "MYSQL_USER" {
  type        = string
  description = ""
}

variable "MYSQL_PASSWORD" {
  type        = string
  description = ""
}

variable "MYSQL_DATABASE" {
  type        = string
  description = ""
}