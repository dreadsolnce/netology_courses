#  Создание базы данных YDB (если нет существующей)
resource "yandex_ydb_database_serverless" "db" {
  name = var.name_db
  folder_id = var.folder_id
}

#  Создание бакета для хранения картинок
resource "yandex_storage_bucket" "image_bucket" {
  bucket = var.name_bucket                                        // Уникальное имя бакета
  # acl = "public-read"
}

# Добавление в объект (бакет, корзину) тестовой картинки
resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.image_bucket.id
  key    = var.name_image_backet                                  // Имя файла, которое он получит в бакете
  source = var.path_to_source_image                              // Путь к локальному файлу, который нужно загрузить
}

variable "name_db" {
  type        = string
  default     = "images-db"
  description = "Имя базы данных"
}

variable "name_bucket" {
  type        = string
  default     = "kolchinvl20260202"
  description = "Бакет для хранения картинок"
}

variable "name_image_backet" {
  type        = string
  description = "Имя файла, которое он получит в бакете"
}

variable "path_to_source_image" {
  type        = string
  default     = "cat.jpg"
  description = "Путь к локальному файлу, который нужно загрузить"
}

output "fileUrl" {
  value = "https://${yandex_storage_bucket.image_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.picture.key}"
  description = "URL для доступа к файлу"
}

