# Сервисный аккаунт для выполнения дипломной работы ---
resource "yandex_iam_service_account" "sa" {
  name        = var.sa
  description = "Сервисный аккаунт для дипломной работы"
  folder_id   = var.folder_id
}

# Назначение роли admin (пока для теста) на каталог ---
resource "yandex_resourcemanager_folder_iam_member" "sa_admin" {
  folder_id   = var.folder_id
  role        = "admin"
  member      = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа для AWS-совместимых сервисов
resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Статический ключ для доступа к Object Storage и Document API"
}

# Сохраняем ключ для доступа к бакету с файлом блокировки состояния tfstate
resource "local_sensitive_file" "save_key" {
  filename = pathexpand("~/.aws/${var.ydb_key}")
  content  = <<EOT
[default]
aws_access_key_id = ${yandex_iam_service_account_static_access_key.sa_static_key.access_key}
aws_secret_access_key = ${yandex_iam_service_account_static_access_key.sa_static_key.secret_key}
EOT
  file_permission = "0600"
}

# Создание ключа для доступа к ресурсам в облаке
resource "yandex_iam_service_account_key" "sa-auth-key" {
  service_account_id = yandex_iam_service_account.sa.id
  key_algorithm      = "RSA_2048"
}

# Сохранение приватного ключа в файл на локальной машине
resource "local_sensitive_file" "key_json" {
  filename = pathexpand("~/keys/${var.auth_key}.json")
  content = jsonencode({
    "id"                 = yandex_iam_service_account_key.sa-auth-key.id
    "service_account_id" = yandex_iam_service_account_key.sa-auth-key.service_account_id
    "created_at"         = yandex_iam_service_account_key.sa-auth-key.created_at
    "key_algorithm"      = yandex_iam_service_account_key.sa-auth-key.key_algorithm
    "public_key"         = yandex_iam_service_account_key.sa-auth-key.public_key
    "private_key"        = yandex_iam_service_account_key.sa-auth-key.private_key
  })
  file_permission = "0600"
}

