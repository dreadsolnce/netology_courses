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

  backend "s3" {
    endpoints = {
      # База данных для хранения блокировок (делается отдельно)
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etn5fc5eukelv6gk3uul"
      # Хранение файла terraform.tfstate
      s3 = "https://storage.yandexcloud.net"
    }

    dynamodb_table = "table_for_save_lockfile_tfstate"

    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    region  = "ru-central1"

    bucket = "tfstate-kvl"
    key    = "catalog/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
#   token     = var.token
  service_account_key_file = file("~/keys/authorized_key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a" #(Optional)
}