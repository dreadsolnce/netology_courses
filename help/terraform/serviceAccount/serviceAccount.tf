# Сервисный аккаунт для группы ВМ ---
resource "yandex_iam_service_account" "service_account" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для группы ВМ"
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = var.service_account_name
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}

variable "service_account_name" {
  type = string
  default = "editor"
  description = "Имя сервисного аккаунта"
}

variable "folder_id" {
  type = string
  default = "b1gdmpusv51ippn2psip"
}

variable "cloud_id" {
  type = string
  default = "b1gr160bk1vuruuer3om"
}

