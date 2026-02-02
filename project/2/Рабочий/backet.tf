#  Создание базы данных YDB (если нет существующей)
resource "yandex_ydb_database_serverless" "db" {
  name = var.name_db
  folder_id = var.folder_id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.groupvm-role,
    yandex_resourcemanager_folder_iam_binding.backet-role
  ]
}

#  Создание бакета для хранения картинок
resource "yandex_storage_bucket" "image_bucket" {
  bucket = var.name_bucket
  acl = "public-read"

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.groupvm-role,
    yandex_resourcemanager_folder_iam_binding.backet-role
  ]
}

# Добавление в объект (бакет, корзину) тестовой картинки
resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.image_bucket.id
  key    = var.name_image_backet                                  // Имя файла, которое он получит в бакете
  source = var.path_to_source_image                              // Путь к локальному файлу, который нужно загрузить
}


