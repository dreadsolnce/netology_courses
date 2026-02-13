# Создание сети для проекта
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

locals {
  flattened_subnets     = flatten([
    for k, v in var.subnets : [
      for k1, v1 in v : {
        name        = v1.name
        zone        = v1.zone
        cidr        = v1.cidr
        description = v1.description
      }
    ]
  ])
}

resource  "yandex_vpc_subnet" "subnet" {
  for_each = { for k in local.flattened_subnets: k.name => k  }
  network_id     = yandex_vpc_network.vpc.id
  name           = each.key
  zone           = each.value.zone
  v4_cidr_blocks = each.value.cidr
  description    = each.value.description
  route_table_id = strcontains(each.value.name, "private") ? yandex_vpc_route_table.route-table.id : null
  # route_table_id = yandex_vpc_route_table.route-table.id
}

# Резервируем статический публичный IP-адрес в зоне ru-central1-a для applications балансировщика
resource "yandex_vpc_address" "alb-public-ip" {
  name = "alb-public-ip"
  external_ipv4_address {
    zone_id = var.alb-public-ip-zone
  }
}


