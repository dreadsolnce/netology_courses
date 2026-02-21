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
  default     = "vpc-test"
  description = "Название сети"
}

variable "subnets" {
  description = "Перечень подсетей где ключ имя проекта (на него можно ссылаться в коде), значение словарь"
  type = map(map(object({
    name = string
    zone = string
    cidr = list(string)
    description = string
  })))
  # noinspection TfIncorrectVariableType
  default = {
    "project-1" = {
      "subnet-project-1-public-a" = {
        name        = "public-project-1-a"
        zone        = "ru-central1-a"
        cidr        = ["192.168.10.0/24"]
        description = "Публичная подсеть для проекта 1 в зоне a"
      },
      "subnet-project-1-public-b" = {
        name        = "public-project-1-b"
        zone        = "ru-central1-b"
        cidr        = ["192.168.11.0/24"]
        description = "Публичная подсеть для проекта 1 в зоне b"
      }
    },
    "project-2" = {
      "subnet-project-2-public-a" = {
        name        = "public-project-2-a"
        zone        = "ru-central1-a"
        cidr = ["192.168.20.0/24"]
        description = "Публичная подсеть для проекта 2 в зоне a"
      },
      "subnet-project-2-private-a" = {
        name        = "private-project-2-a"
        zone        = "ru-central1-a"
        cidr = ["192.168.120.0/24"]
        description = "Приватная подсеть для проекта 2 в зоне a"
      }
    },
    "k8s" = {
       "subnet-public-a" = {
         name        = "k8s-public-a"
         zone        = "ru-central1-a"
         cidr        = ["192.168.40.0/24"]
         description = "Публичная подсеть для проекта k8s в зоне a"
       },
       "subnet-public-b" = {
         name        = "k8s-public-b"
         zone        = "ru-central1-b"
         cidr        = ["192.168.50.0/24"]
         description = "Публичная подсеть для проекта k8s в зоне b"
       },
       "subnet-public-d" = {
         name        = "k8s-public-d"
         zone        = "ru-central1-d"
         cidr        = ["192.168.60.0/24"]
         description = "Публичная подсеть для проекта k8s в зоне d"
       }
    }
  }
}
