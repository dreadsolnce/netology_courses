#---------------Создание репозитория Container Registry----------------------------------------
resource "yandex_container_registry" "registry" {
  name = var.registry
  folder_id = var.yc_folder_id
}

#---------------Создание сервисного аккаунта--------------------------------------------------
resource "yandex_iam_service_account" "gitlab" {
  name = var.gitlab-sa
  folder_id = var.yc_folder_id
}

#---------------Назначение роли сервисному аккаунту------------------------------------------
resource "yandex_resourcemanager_folder_iam_member" "role_registry" {
  for_each = toset(var.roles)
  folder_id   = var.yc_folder_id
  member      = "serviceAccount:${yandex_iam_service_account.gitlab.id}"
  role        = each.value
  depends_on = [
        yandex_container_registry.registry,
        yandex_iam_service_account.gitlab,
  ]
}