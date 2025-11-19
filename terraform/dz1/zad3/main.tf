terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
  required_version = ">=1.8.4" /*Многострочный комментарий.
 Требуемая версия terraform */
}

provider "docker" {
  host = "ssh://ubuntu@51.250.92.112:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "random_password" "root_password" {
  length = 8
}

resource "random_password" "password" {
  length = 8
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.name
  name  = "mytestmysql"

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.password.result}",
    "MYSQL_ROOT_HOST=localhost"
  ]

  ports {
    internal = 3306
    external = 3306
    ip = "127.0.0.1"
  }
}