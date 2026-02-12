# Целевые группы для VM: front, back (yandex_lb_target_group) указывает балансировщику, куда направлять трафик.
resource "yandex_alb_target_group" "target-group" {
  for_each = var.alb

  name              = each.value.name_tg

  target {
    ip_address  = each.key == "front" ? var.settingsVM.front.ipaddress : (each.key == "back" ? var.settingsVM.back.ipaddress : "unknown")
    subnet_id   = each.key == "front" ? yandex_vpc_subnet.subnet-public["public-1"].id : (each.key == "back" ? yandex_vpc_subnet.subnet-private["private-1"].id : "unknown")
  }
}

# Группы бэкендов, которые использует целевую группу
resource "yandex_alb_backend_group" "backend-group" {
  for_each = var.alb

  name = each.value.name_bg

  http_backend {
    name = var.group_backend.name
    port = var.group_backend.port
    target_group_ids =  [yandex_alb_target_group.target-group[each.key].id]

    healthcheck {
      timeout = var.group_backend.health_timeout
      interval = var.group_backend.health_interval
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Создание роутера
resource "yandex_alb_http_router" "http-router" {
  name = var.name_router
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "virtual-host" {
  name           = var.name_virualhost
  http_router_id = yandex_alb_http_router.http-router.id
  authority      = ["*"]

  dynamic "route" {
    for_each = var.alb
    content {
      name = route.value.name_route_http
      http_route {
        http_match {
          path {
            prefix = route.value.prefix
          }
        }
        http_route_action {
          backend_group_id = yandex_alb_backend_group.backend-group[route.key].id
          timeout          = "3s"
          prefix_rewrite   = route.value.prefix_rewrite # Новое значение пути
        }
      }
    }
  }
}

# Создание Application Load Balancer
resource "yandex_alb_load_balancer" "create-alb" {
  name       = var.name_balancer
  network_id = yandex_vpc_network.vpc-netology.id

  # Определяем обработчик для входящего трафика
  listener {
    # name = each.value.name_listen
    name = var.name_listen

    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.public-ip-app.external_ipv4_address[0].address
        }
      }
      ports = var.port_listen
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
  # Размещаем балансировщик в подсети
  allocation_policy {
    location {
      zone_id   = var.subnets-public["public-1"].zone
      subnet_id = yandex_vpc_subnet.subnet-public["public-1"].id
    }
    # location {
    #   zone_id   = var.subnets-private["private-1"].zone
    #   subnet_id = yandex_vpc_subnet.subnet-private["private-1"].id
    # }
  }
}
