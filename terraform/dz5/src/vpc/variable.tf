###cloud vars
# variable "cloud_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
# }
#
# variable "folder_id" {
#   type        = string
#   description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
# }

variable "env_name" {
    type        = string
    default     = null
    description = "Название сети"
}

variable "zone" {
    type        = string
    default     = "ru-central1-a"
    description = "Используемая зона"
}

variable "cidr" {
    type        = string
    description = "Используемая сеть. Обязательный параметр, т.к. не указано значение по умолчанию"
}
