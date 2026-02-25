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
  backend "s3" {
    endpoints = {
     # База данных для хранения блокировок (делается отдельно)
     dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etncq1kd307acbfs2hsi"
     # Хранение файла terraform.tfstate
     s3 = "https://storage.yandexcloud.net"
    }

    shared_credentials_files = ["~/.aws/credentials-diplom"]
    region  = "ru-central1"


    dynamodb_table = "tb-lock-diplom"
    profile = "default"

    bucket = "tfstate-b1gdmpusv51ippn2psip"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  cloud_id                  = var.cloud_id
  folder_id                 = var.folder_id
  zone                      = var.default-zone
  service_account_key_file  = local.sa_key_file
}

# provider "aws" {
#   alias  = "ydb"
#   region = var.name_location
#
#   # Эндпоинт берется из созданной БД (смотри _ydb.tf)
#   endpoints {
#     dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etncq1kd307acbfs2hsi"
#   #   #dynamodb = yandex_ydb_database_serverless.tfstate_db.ydb_api_endpoint
#   #   #dynamodb =  yandex_ydb_database_serverless.tfstate_db.ydb_full_endpoint
#   #   # dynamodb = yandex_ydb_database_serverless.tfstate_db.document_api_endpoint
#   }
#
#   shared_credentials_files = ["~/.aws/${var.ydb_key}"]
#
#   skip_region_validation      = true
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true
# }

 # backend "s3" {
 #   endpoints = {
 #     # База данных для хранения блокировок (делается отдельно)
 #     dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etnqvsp4l8t1hduha5mf"
 #     # Хранение файла terraform.tfstate
 #     s3 = "https://storage.yandexcloud.net"
 #   }
 #
 #   shared_credentials_files = ["~/.aws/credentials-diplom"]
 #   region  = "ru-central1"
 #
 #
 #   dynamodb_table = "tb-lock"
 #   profile = "default"
 #
 #   bucket = "tfstate-b1gdmpusv51ippn2psip"
 #   key    = "terraform.tfstate"
 #
 #   skip_region_validation      = true
 #   skip_credentials_validation = true
 #   skip_requesting_account_id  = true
 #   skip_s3_checksum            = true
 # }