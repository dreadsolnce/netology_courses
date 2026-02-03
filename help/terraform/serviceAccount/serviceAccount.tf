# Тестовый сервисный аккаунт для группы ВМ ---
resource "yandex_iam_service_account" "service_account" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для группы ВМ"
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = var.role_sa_editor
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "admin" {
  folder_id = var.folder_id
  role      = var.role_sa_admin
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}

variable "service_account_name" {
  type = string
  default = "sa-group"
  description = "Имя сервисного аккаунта"
}

variable "role_sa_editor" {
  type = string
  default = "editor"
  description = "Роль editor для создаваемого сервисного аккаунта"
}

variable "role_sa_admin" {
  type = string
  default = "admin"
  description = "Роль admin для создаваемого сервисного аккаунта"
}

variable "folder_id" {
  type = string
  description = "Идентификатор каталога в облаке"
}

variable "cloud_id" {
  type = string
  description = "Идентификатор облака"
}

