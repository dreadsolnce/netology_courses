resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Публичная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_public" {
  name           = var.subnets["public"].name
  zone           = var.subnets["public"].zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.subnets["public"].cidr]
}

# Приватная подсеть
resource "yandex_vpc_subnet" "vpc_subnet_private" {
  name           = var.subnets["private"].name
  zone           = var.subnets["private"].zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [var.subnets["private"].cidr]
  route_table_id = yandex_vpc_route_table.rt.id
}

# resource "yandex_vpc_subnet" "subnet" {
#   for_each = var.subnets
#
#   name           = each.key
#   zone           = each.value.zone
#   network_id     = yandex_vpc_network.vpc-netology.id
#   v4_cidr_blocks = [each.value.cidr]
#   route_table_id = each.key == "private" ? yandex_vpc_route_table.rt.id : null
# }

