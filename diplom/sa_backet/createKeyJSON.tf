# # Создание статического ключа доступа (JSON)
# resource "yandex_iam_service_account_static_access_key" "sa_key" {
#   service_account_id = yandex_iam_service_account.sa.id
#   description        = "Ключ для сервисного аккаунта diplom"
# }
#
# # Сохранение ключа в файл JSON
# resource "local_file" "sa_key_json" {
#   filename = "${yandex_iam_service_account.sa.name}_key.json"
#   content  = jsonencode({
#     id           = yandex_iam_service_account_static_access_key.sa_key.id
#     service_account_id = yandex_iam_service_account.sa.id
#     created_at   = yandex_iam_service_account_static_access_key.sa_key.created_at
#     key_algorithm = yandex_iam_service_account_static_access_key.sa_key.encrypted_secret_key
#     access_key   = yandex_iam_service_account_static_access_key.sa_key.access_key
#     secret_key   = yandex_iam_service_account_static_access_key.sa_key.secret_key
#   })
#
#   provisioner "local-exec" {
#     command = "chmod 600 ${self.filename}"
#   }
# }
