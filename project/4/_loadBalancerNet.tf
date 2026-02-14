# Целевая группа (yandex_lb_target_group) указывает балансировщику, куда направлять трафик.
resource "yandex_lb_target_group" "group-lb-target" {
  name              = "target-group-vm"
  region_id         = "ru-central1"

  dynamic "target" {
    for_each = toset(data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].ip_address)
    content {
      address =target.value
#      subnet_id = yandex_vpc_subnet.subnet-public["public-1"].id
      subnet_id = yandex_vpc_subnet.subnet[var.subnets.app_lamp.subnet-private-a.name].id
    }
  }
}

# --- Сетевой балансировщик ---
resource "yandex_lb_network_load_balancer" "load-balancer" {
  name = var.lb_name

  # Настраиваем обработчик входящего трафика
  listener {
    name = "http-listener"
    port = 80                 # Внешний порт, который будет слушать балансировщик
    protocol = "tcp"
    target_port = 80          # Внутренний порт на ВМ, куда пойдет трафик

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Привязываем целевую группу и настраиваем проверку состояния
  attached_target_group {
    target_group_id = yandex_lb_target_group.group-lb-target.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80                     # Порт для проверки на ВМ
        path = "/index.html"          # Путь для проверки
      }
    }
  }
}
