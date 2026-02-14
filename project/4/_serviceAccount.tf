# Тестовый сервисный аккаунт для групп ВМ ---
resource "yandex_iam_service_account" "service-account" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для проекта"
}

# Назначаем роль editor сервисному аккаунту, чтобы он мог управлять ресурсами
resource "yandex_resourcemanager_folder_iam_binding" "account-role-compute" {
  folder_id = var.folder_id
  role      = var.service_account_role.role_admin
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
  role      = var.service_account_role.role_vpc
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}",
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

resource "yandex_kms_symmetric_key_iam_binding" "account-role-kms" {
  symmetric_key_id = yandex_kms_symmetric_key.kms-key.id
  role = var.service_account_role.role_kms
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}"
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

# Назначение роли kluster для сервисного аккаунта devops
resource "yandex_resourcemanager_folder_iam_binding" "account-role-k8s" {
  folder_id = var.folder_id
  role = var.service_account_role.role_container
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}"
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

# Назначение роли kluster для сервисного аккаунта devops
resource "yandex_resourcemanager_folder_iam_binding" "account-role-k8s-admin" {
  folder_id = var.folder_id
  role = var.service_account_role.role_k8s
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}"
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

# Назначение роли kluster для сервисного аккаунта devops
resource "yandex_resourcemanager_folder_iam_binding" "account-role-k8s-cluster" {
  folder_id = var.folder_id
  role = var.service_account_role.role_cluster
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}"
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}

# Назначение роли kluster для сервисного аккаунта devops
resource "yandex_resourcemanager_folder_iam_binding" "account-role-k8s-balancer" {
  folder_id = var.folder_id
  role = var.service_account_role.role_balancer
  members = [
    "serviceAccount:${yandex_iam_service_account.service-account.id}"
  ]
  depends_on = [
    yandex_iam_service_account.service-account,
  ]
}
