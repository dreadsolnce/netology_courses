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

# 2. Настройка AWS-провайдера для работы с YDB Document API
provider "aws" {
  alias  = "ydb"
  region = "ru-central1"
  
  # Эндпоинт берется из созданной БД
  endpoints {
    #dynamodb = yandex_ydb_database_serverless.tfstate_db.ydb_api_endpoint
    #dynamodb =  yandex_ydb_database_serverless.tfstate_db.ydb_full_endpoint
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etnerhbmnj4ih7t0o0mv"
  }
  
  # Значения могут быть любыми, но они обязательны для провайдера
  #access_key = "mock_access_key"
  #secret_key = "mock_secret_key"
  shared_credentials_files = ["~/.aws/key"]
  
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# 3. Документная таблица для блокировок
resource "aws_dynamodb_table" "tf_lock_table" {
  provider     = aws.ydb
  name         = "tf-state-lock-table"
  hash_key     = "LockID" # Обязательное имя для Terraform Lock
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}



# Таблица блокировок для Terraform state в YDB
# 3. Создание таблицы в YDB для блокировок
# Важно: имя таблицы и структура (LockID) должны соответствовать требованиям S3 backend
#resource "yandex_ydb_table" "state_lock_table" {
#  path              = "tstate-lock-table"
  
#  connection_string = yandex_ydb_database_serverless.tfstate_db.ydb_full_endpoint
  
#  Создание документной таблицы в YDB для блокировок через terraform
# Создание документной таблицы для блокировок

  # Настройка таблицы как документной (Document Table)
#  document_table {
    # Ключ партиционирования (обязателен для блокировок)
#    hash_key = "LockID" 
#  }

  # Определение колонок
#  column {
#    name = "LockID"
#    type = "Utf8"
#  }

#  primary_key = ["LockID"]
#}

# Создание бакета для хранения файла terraform.tfstate ---
resource "yandex_storage_bucket" "tfstate" {
  bucket     = "tfstate-${var.folder_id}"
  folder_id  = var.folder_id
  max_size   = 1073741824  # 1 GB

  # Версионирование для отката изменений
  #versioning {
  #  enabled = true
  #}

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
