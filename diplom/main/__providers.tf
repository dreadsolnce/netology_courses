terraform {
  # required_version = ">=1.14.6"
  required_version = ">=1.14.3"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      # version = "0.187.0"
      version = "0.191.0"
    }

    ## template = {
    ##   source  = "hashicorp/template"
    ##   version = "2.2.0"
    ## }
  }
  backend "s3" {
    # endpoints = {
    #  # База данных для хранения блокировок (делается отдельно)
    #  dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gr160bk1vuruuer3om/etncq1kd307acbfs2hsi"
    #  # Хранение файла terraform.tfstate
    #  s3 = "https://storage.yandexcloud.net"
    # }
    # endpoint = "https://storage.yandexcloud.net"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    bucket = "tfstate-b1gdmpusv51ippn2psip"
    region  = "ru-central1"
    key    = "terraform.tfstate"

    shared_credentials_files = ["~/.aws/credentials-diplom"]
    # profile = "default"

    # dynamodb_table = "tb-lock-diplom" # Старая версия блокировки файла состояния
    use_lockfile = true                 # Используется нативная блокировка S3 начиная с версии 1.10

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  cloud_id                  = var.yc_cloud_id
  folder_id                 = var.yc_folder_id
  zone                      = var.default-zone
  service_account_key_file  = file(var.auth_key_sa_yandex)
}

