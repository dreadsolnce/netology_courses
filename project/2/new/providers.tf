terraform {
  required_version = ">=1.9.8"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.157.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "yandex" {
  # token     = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/keys/authorized_key.json")
}

