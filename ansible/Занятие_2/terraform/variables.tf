###cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

# Переменная IAM token которая хранится в переменной окружения TF_VAR_yc_token
# variable "yc_token" {}

# variable "ssh_key" {
#   type = string
#   description = "открытый ssh ключ для подключения к серверу"
# }

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# Переменные создания первых двух машин

variable "nameVMWeb" {
  type     = string
  default  = "web"
}

variable "resourcesVMWeb" {
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

variable "resourcesVMDb" {
  type = list(object(
    {
      vm_name=string,
      cpu=number,
      ram=number,
      core_fraction=number,
      disk_volume=number
    }
  ))
  default = [
    {
      vm_name = "main"
      cpu = 4
      ram = 4
      core_fraction = 20
      disk_volume = 20
    },
    {
      vm_name = "replica"
      cpu = 2
      ram = 1
      core_fraction = 20
      disk_volume = 10
    }
  ]
}