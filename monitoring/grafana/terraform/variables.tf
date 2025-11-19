###cloud vars
variable "cloud_id" {
  type        = string
  default     = "b1gr160bk1vuruuer3om"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gh1tm69ej6s5k9qube"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "service_account_key_file" {
  type        = string
  default     = "~/keys/authorized_key_docker_swarm.json"
  description = "Путь к ключу для подключения к сервисному акаунту"
}

variable "ssh_pub_key" {
  default  = "~/.ssh/id_rsa.pub"
}
######################## переменные сети ##############################################
variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона доступности"
}

variable "cidr_net" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Диапазон ip адресов внутренней сети"
}

variable "vpc_name" {
   type        = string
   default     = "vpc_teamcity"
   description = "Название сети"
}

variable "vpc_subnet_name" {
  type        = string
  default     = "subnet-teamcity"
  description = "Название подсети"
}

variable "imageID" {
  type        = string
  default     = "fd8d464f5srt40f0mftt"
  description = "id образа виртуальной машины"
}

variable "instance_name" {
  type        = list(string)
  default     = ["prometheus"]
  description = "Имена создаваемых машин"
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
    memory        = 4
    core_fraction = 100
  }
  description = "Ресурсы для создания первых двух машин"
}
