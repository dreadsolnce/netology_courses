# Создание сети для проекта
resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Создание 2-ух приватных подсетей для проекта в разных зонах
resource "yandex_vpc_subnet" "subnet-private" {
  for_each = var.subnets-private

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = each.value.cidr
  description    = each.value.description
  # route_table_id = each.value.name == "private" ? yandex_vpc_route_table.rt.id : null
  # Применяем таблицу маршрутизации, т.к. ВМ будут без публичного адреса
  route_table_id = yandex_vpc_route_table.rt.id
}

# Создание 3-ех публичных подсетей для проекта в разных зонах
resource "yandex_vpc_subnet" "subnet-public" {
  for_each = var.subnets-public

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = each.value.cidr
  description    = each.value.description
  # route_table_id = each.value.name == "private" ? yandex_vpc_route_table.rt.id : null
  # Применяем таблицу маршрутизации, т.к. ВМ будут без публичного адреса
  # route_table_id = yandex_vpc_route_table.rt.id
}

# Резервируем статический публичный IP-адрес для балансировщика
resource "yandex_vpc_address" "public-ip-app" {
  name = "public-ip-alb"
  external_ipv4_address {
    zone_id = var.public-zone-ip
  }
}


