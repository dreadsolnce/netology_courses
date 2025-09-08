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
}

variable "subnet_zone" {
    type        = list
    default     = ["ru-central1-a", "ru-central1-b"]
    description = "Используемые зоны в проекте"
}

variable "subnet_name" {
    type        = list
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
  description = "Название инстансов создаваемых vm"
}

variable "my_label" {
  type    = object({
    owner   = string,
    project = list(string)
  })
  default = { owner = "kolchin_vladimir", project = ["analytics", "marketing"]}

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



