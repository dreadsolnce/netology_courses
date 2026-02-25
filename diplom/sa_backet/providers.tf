terraform {
  required_version = ">=1.9.8"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.187.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }

#  backend "s3" {
#    endpoints = {
#      # База данных для хранения блокировок (делается отдельно)
#      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etnerhbmnj4ih7t0o0mv"
#      # Хранение файла terraform.tfstate
#      s3 = "https://storage.yandexcloud.net"
#    }

#    shared_credentials_files = ["~/.aws/key"]
#    region  = "ru-central1"


#    dynamodb_table = "tstate-lock-table"
#
#    profile = "default"
#
#    bucket = "tfstate-b1gdmpusv51ippn2psip"
#    key    = "terraform.tfstate"

#    skip_region_validation      = true
#    skip_credentials_validation = true
#    skip_requesting_account_id  = true
#    skip_s3_checksum            = true
#  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
  service_account_key_file = local.sa_key_file
}
