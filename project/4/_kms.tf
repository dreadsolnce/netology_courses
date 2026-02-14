resource "yandex_kms_symmetric_key" "kms-key" {
  name                = var.kms_key.name
  folder_id           = var.folder_id
  description         = "Симметричный ключ для шифрования картинки из бакета"
  default_algorithm   = var.kms_key.algorithm
  rotation_period     = var.kms_key.period
  deletion_protection = var.kms_key.protect
}

output "kms_key_id" {
  description = "ID симметричного ключа"
  value = yandex_kms_symmetric_key.kms-key.id
}
