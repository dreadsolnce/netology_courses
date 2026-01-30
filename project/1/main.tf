resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Публичная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_public" {
  name           = var.vpc_subnet_name[0]
  zone           = var.zone[0]
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.cidr[0]]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_private" {
  name           = var.vpc_subnet_name[1]
  zone           = var.zone[1]
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.cidr[1]]
  route_table_id = yandex_vpc_route_table.rtNat.id
}
