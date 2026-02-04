output "fileUrl" {
  value = "https://${yandex_storage_bucket.image_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.picture.key}"
  description = "URL для доступа к файлу"
}

# output "roles" {
#   description = "The ID of the created multi-role service account"
#   value       = yandex_iam_service_account.service_account.id
# }
