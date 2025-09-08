###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

###cloud vars network

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr_develop_b" {
    type        = list(string)
    default     = ["10.0.2.0/24"]
    description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
  validation {
      condition = contains(["prod", "develop"], var.vpc_name)
      error_message = "Не поддерживаемое имя сети"
    }
}

variable "subnet_zone" {
    type        = list(string)
    default     = ["ru-central1-a", "ru-central1-b"]
    description = "Используемые зоны в проекте"
}

variable "subnet_name" {
    type        = list(string)
    default     = ["develop-ru-central1-a", "develop-ru-central1-b"]
    description = "Имена используемых подсетей"
}

###common vars
variable "name_os" {
    type        = string
    default     = "ubuntu-2004-lts"
    description = "Версия используемой ОС"
}

variable "public_ip_address" {
    type        = bool
    default     = true
    description = "Использование публичного адреса"
}

variable "env_name" {
    type        = list(string)
    default     = [ "develop", "stage" ]
    description = "Рабочее окружение"
}

variable "vms_ssh_root_key" {
    type    = string
    default = "~/.ssh/id_rsa.pub"
    description = "Публичный ключ для подключения по протоколу ssh к создаваемым vm"
}

variable "packages" {
    type        = list(string)
    default     = [ "vim", "nginx" ]
    description = "Устанавливаемые пакеты по умолчанию"
}

variable "instance_name" {
  type        = list(string)
  default     = ["webs", "web-stage"]
  description = "Название инст ансов создаваемых vm"
}

variable "my_label" {
  default = { owner = "kolchin_vladimir", project = ["analytics", "marketing"]}
  validation {
    condition = length(var.my_label.owner) > 0
    error_message = "Поле owner должно содержать хотя бы один символ"
  }
}

variable "testIP_1" {
  type        = string
  default     =  "192.168.0.1"
  description = "ip адрес"
  validation {
    condition = can(cidrhost(join("/",tolist([var.testIP_1, "32"])), 0))
    error_message = "Не верный ip адрес"
  }
}

variable "testIP_2" {
  type        = list(string)
  default     =  ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
  description = "список ip-адресов — проверка, что все адреса верны"
  validation {
    condition = alltrue([for i in var.testIP_2: can(cidrhost(join("/",tolist([i, "32"])), 0))])
    error_message = "Список содержит не верный ip адрес"
  }
}

# ###example vm_web var
# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
#   description = "example vm_web_ prefix"
# }
#
# ###example vm_db var
# variable "vm_db_name" {
#   type        = string
#   default     = "netology-develop-platform-db"
#   description = "example vm_db_ prefix"
# }



