
# Создание YDB Database для хранения файла состояния---
resource "yandex_ydb_database_serverless" "tfstate_db" {
  name      = var.name_ydb
  folder_id = var.folder_id

  location_id = var.name_location

  serverless_database {
    storage_size_limit = 1
  }

  lifecycle {
    # Защита от удаления отключена
    prevent_destroy = false
  }
}

# Создание документной таблицы для блокировок
resource "aws_dynamodb_table" "tf_lock_table" {
  provider     = aws.ydb
  name         = var.name_dynamodb_table
  hash_key     = "LockID" # Обязательное имя для Terraform Lock
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Создание бакета для хранения файла terraform.tfstate ---
resource "yandex_storage_bucket" "tfstate" {
  bucket    = "tfstate-${var.folder_id}"
  folder_id = var.folder_id
  max_size  = 1073741824  # Значение в байтах = 1 GB
}
  # Дополнительные значения для бакета
  # # Версионирование для отката изменений
  # versioning {
  #  enabled = true
  # }

  # # Очистка старых версий
  # lifecycle_rule {
  #   id      = "cleanup"
  #   enabled = true
  #   noncurrent_version_expiration {
  #     days = 30
  #   }
  # }

  # Принудительное HTTPS
  # force_destroy = false

