terraform {
  required_version = ">=1.9.8"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.187.0"
    }

    # template = {
    #   source  = "hashicorp/template"
    #   version = "2.2.0"
    # }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default-zone
  service_account_key_file = local.auth_key_file
}

provider "aws" {
  alias  = "ydb"
  region = var.name_location

  # Эндпоинт берется из созданной БД (смотри _ydb.tf)
  endpoints {
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etncq1kd307acbfs2hsi"
  #   #dynamodb = yandex_ydb_database_serverless.tfstate_db.ydb_api_endpoint
  }

  shared_credentials_files = ["~/.aws/${var.ydb_key}"]

  skip_region_validation      = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}
