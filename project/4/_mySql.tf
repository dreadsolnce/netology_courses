# Создание кластера MySQL
resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
  name                = var.cluster.name
  environment         = var.cluster.type # Или "PRESTABLE" для тестовых сред
  network_id          = yandex_vpc_network.vpc-netology.id
  version             = var.cluster.version
  # label               = {
  #   project = "netology-course"
  # }

  resources {
    resource_preset_id = var.cluster_resources.resource_preset_id # Тип вычислительных ресурсов (например, "s2.micro", "m3.medium")
    disk_type_id       = var.cluster_resources.disk_type_id # Тип диска (например, "network-hdd", "network-ssd", "local-ssd")
    disk_size          = var.cluster_resources.disk_size # Размер диска в гигабайтах
  }

  dynamic "host" {
    for_each = yandex_vpc_subnet.subnet-private
    content {
      zone      = host.value.zone
      subnet_id = host.value.id
    }
  }

  # Защита от удаления
  deletion_protection = var.cluster.protection

  maintenance_window {
    type = var.cluster.maintenance
  }

  backup_window_start {
    hours   = var.cluster.backup.hours
    minutes = var.cluster.backup.minute
  }
}

resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = var.database.name
}

resource "yandex_mdb_mysql_user" "db-user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
  name       = var.database.user
  password   = var.password_database
  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles = var.database.roles
  }
}
