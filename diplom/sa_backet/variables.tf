##cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

######################### Переменные для сервисного аккаунта ###############################################
variable "sa" {
  type = string
  default = "diplom"
  description = "Имя сервисного аккаунта"
}