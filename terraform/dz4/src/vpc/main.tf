terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"  ### some test
}

# provider "yandex" {
# #   token     = var.token
#   service_account_key_file = file("~/keys/authorized_key.json")
#   cloud_id                 = var.cloud_id
#   folder_id                = var.folder_id
# }

# Создание новой сети develop
resource "yandex_vpc_network" "develop" {
  name = var.env_name == null ? "unknown" : var.env_name
}

# Создание новой подсети
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [var.cidr]
}