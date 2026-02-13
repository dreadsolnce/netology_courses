# # Создание кластера MySQL
# resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
#   name                = var.cluster_mysql.name
#   environment         = var.cluster_mysql.type                          # Или "PRESTABLE" для тестовых сред
#   network_id          = yandex_vpc_network.vpc-netology.id
#   version             = var.cluster_mysql.version
#   # label               = {
#   #   project = "netology-course"
#   # }
#
#   # Мощность железа
#   resources {
#     resource_preset_id = var.cluster_mysql_resources.resource_preset_id # Тип вычислительных ресурсов (например, "s2.micro", "m3.medium")
#     disk_type_id       = var.cluster_mysql_resources.disk_type_id       # Тип диска (например, "network-hdd", "network-ssd", "local-ssd")
#     disk_size          = var.cluster_mysql_resources.disk_size          # Размер диска в гигабайтах
#   }
#
#   # Добавляем хосты базы данных в приватную зону
#   dynamic "host" {
#     for_each = yandex_vpc_subnet.subnet-private
#     content {
#       zone      = host.value.zone
#       subnet_id = host.value.id
#     }
#   }
#
#   # Защита от удаления
#   deletion_protection = var.cluster_mysql.protection
#
#   # Время обслуживания
#   maintenance_window {
#     type = var.cluster_mysql.maintenance
#   }
#
#   # Время резервного копирования
#   backup_window_start {
#     hours   = var.cluster_mysql.backup.hours
#     minutes = var.cluster_mysql.backup.minute
#   }
# }
#
# # Создание базы данных в созданном кластере MySQL
# resource "yandex_mdb_mysql_database" "db" {
#   cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
#   name       = var.database.name
# }
#
# # Создание пользователя в созданном кластере MySQL
# resource "yandex_mdb_mysql_user" "db-user" {
#   cluster_id = yandex_mdb_mysql_cluster.mysql-cluster.id
#   name       = var.database.user
#   password   = var.password_database
#   permission {
#     database_name = yandex_mdb_mysql_database.db.name
#     roles = var.database.roles
#   }
# }
