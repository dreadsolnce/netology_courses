resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = var.subnets

  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc-netology.id
  v4_cidr_blocks = [each.value.cidr]
  route_table_id = each.key == "private" ? yandex_vpc_route_table.rt.id : null
}

