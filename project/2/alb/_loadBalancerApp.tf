# Целевая группа (yandex_lb_target_group) указывает балансировщику, куда направлять трафик.

resource "yandex_alb_target_group" "group-alb-target" {
  name              = "target-group-alb"

  target {
    ip_address  = var.settingsVM.front.ipaddress
    subnet_id   = yandex_vpc_subnet.subnet["public"].id
  }
}

# Целевая группа для back серверов
resource "yandex_alb_target_group" "tg-back" {
  name              = "tg-back"

  target {
    ip_address  = var.settingsVM.back.ipaddress
    subnet_id   = yandex_vpc_subnet.subnet["private"].id
  }
}

# Группы бэкендов, которые использует целевую группу
resource "yandex_alb_backend_group" "backend-group-front" {
  name = "backend-group-front"

  http_backend {
    name = "http-backend"
    port = 80
    target_group_ids = [yandex_alb_target_group.group-alb-target.id]

    healthcheck {
      timeout = "1s"
      interval = "2s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Создание роутера
resource "yandex_alb_http_router" "http-router-front" {
  name = "http-router-front"
}

# Создание виртуального хоста
resource "yandex_alb_virtual_host" "virtual-host-front" {
  name           = "vh-front"
  http_router_id = yandex_alb_http_router.http-router-front.id
  authority      = ["*"]

  route {
    name = "route-front"
    http_route {
      http_match {
        path {
          prefix = "/web" # <-- Указание: путь начинается с /api/
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group-front.id
        timeout = "3s"
        prefix_rewrite = "/" # Новое значение пути
      }
    }
  }
}

# Создание Application Load Balancer
resource "yandex_alb_load_balancer" "alb" {
  name        = "load-balancer-app"
  network_id  = yandex_vpc_network.vpc-netology.id

# Определяем обработчик для входящего трафика
  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.public-ip-app.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router-front.id
      }
    }
  }

# Размещаем балансировщик в подсети
  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet["public"].id
    }
  }
}
