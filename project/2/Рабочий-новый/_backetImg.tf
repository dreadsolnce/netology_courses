#  Создание базы данных YDB (если нет существующей)
resource "yandex_ydb_database_serverless" "db" {
  name = var.name_db
  folder_id = var.folder_id
}

#  Создание бакета для хранения картинок
resource "yandex_storage_bucket" "bucket-image" {
  bucket = var.bucket_name
  acl = "public-read"
}

# Добавление в объект (бакет, корзину) тестовой картинки
resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.bucket-image.id
  key    = var.bucket_image                                   // Имя файла, которое он получит в бакете
  source = var.bucket_image_path                              // Путь к локальному файлу, который нужно загрузить
}




