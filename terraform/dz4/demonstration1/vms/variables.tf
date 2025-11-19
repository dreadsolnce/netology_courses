###cloud vars

variable "ssh_public_key" {
    type    = string
    default = "~/.ssh/id_rsa.pub"
    description = "Публичный ключ для подключения по протоколу ssh к создаваемым vm"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
#-----------------------------------------------------------------------------------------
###vm vars

variable "packages" {
    type        = list
    default     = [ "vim", "nginx" ]
    description = "Устанавливаемые пакеты по умолчанию"
}
#-----------------------------------------------------------------------------------------