# Сервисный аккаунт для группы ВМ ---
resource "yandex_iam_service_account" "service_account" {
  name        = var.service_account_name
  folder_id   = var.folder_id
  description = "Сервисный аккаунт для группы ВМ с ролью editor и доступа к бакету"
}

# Назначаем роль admin сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "groupvm-role" {
  folder_id = var.folder_id
  role      = var.service_account_role
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "backet-role" {
  folder_id = var.folder_id
  role  = "storage.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_role" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"

  members = [
    "serviceAccount:${yandex_iam_service_account.service_account.id}",
  ]
}



