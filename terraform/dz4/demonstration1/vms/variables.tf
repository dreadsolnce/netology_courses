###cloud vars

# variable "public_key" {
#   type    = string
#   default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGiVcfW8Wa/DxbBNzmQcwn7hJOj7ji9eoTpFakVnY/AI webinar"
# }

# variable nameservers {
#   type    = list
#   default = []
# }

variable "packages" {
    type        = list
    default     = [ "vim", "nginx" ]
    description = "Устанавливаемые пакеты по умолчанию"
}

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