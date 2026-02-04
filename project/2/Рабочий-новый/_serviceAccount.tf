# Тестовый сервисный аккаунт для групп ВМ ---
resource "yandex_iam_service_account" "service-account" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для группы ВМ"
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "account-role-compute" {
  folder_id = var.folder_id
  role      = var.role_sa
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}",
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "account-role-vpc" {
  folder_id = var.folder_id
  role      = var.role_sa_vpc
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}",
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

