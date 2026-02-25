##cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "name_location" {
  type      = string
  default   = "ru-central1"
  description = "Географический регион"
}

variable "default-zone" {
  type      = string
  default   = "ru-central1-a"
  description = "Зона доступности по умолчанию"
}

######################### Переменные для сервисного аккаунта ###############################################
variable "sa" {
  type = string
  default = "sa-diplom"
  description = "Имя сервисного аккаунта"
}

variable "ydb_key" {
  type    = string
  default = "credentials-diplom"
  description = "Имя файла с ключами для доступа к бакету s3"
}

variable "auth_key" {
  type        = string
  default     = "authorized-key-diplom"
  description = "Имя файла с ключами для работы с ресурсами в yandex облаке"
}

######################### Переменные для ydb ###############################################
variable "name_ydb" {
  type        = string
  default     = "ydb-diplom"
  description = "Имя базы данных ydb"
}

variable "name_dynamodb_table" {
  type        = string
  default     = "tb-lock-diplom"
  description = "Имя документной таблицы "
}