# Сервисный аккаунт для выполнения дипломной работы ---
resource "yandex_iam_service_account" "sa" {
  name        = var.sa
  description = "Сервисный аккаунт для дипломной работы"
  folder_id   = var.folder_id
}

# Назначение роли admin на каталог ---
resource "yandex_resourcemanager_folder_iam_member" "sa_admin" {
  folder_id   = var.folder_id
  role        = "admin"
  member      = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание YDB Database ---
resource "yandex_ydb_database_serverless" "tfstate_db" {
  name      = "tfstate-database"
  folder_id = var.folder_id

  location_id = "ru-central1"

  lifecycle {
    prevent_destroy = false
  }
}

# Создание бакета для хранения файла terraform.tfstate ---
resource "yandex_storage_bucket" "tfstate" {
  bucket     = "tfstate-${var.folder_id}"
  folder_id  = var.folder_id
  max_size   = 1073741824  # 1 GB

  # Версионирование для отката изменений
  versioning {
    enabled = true
  }

  # Очистка старых версий
  lifecycle_rule {
    id      = "cleanup"
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }

  # Принудительное HTTPS
  force_destroy = false
}
