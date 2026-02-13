# Группы безопасности для проекта AppWebBack
resource "yandex_vpc_security_group" "sg-app-web-back-public" {
  name = "app-web-back-public"
  network_id = yandex_vpc_network.vpc.id
  description = "Security group для публичных сервисов проекта AppWebBack"

# Разрешить весь трафик!
  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow all incoming traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg-app-web-back-private" {
  name        = "app-web-back-private"
  network_id  = yandex_vpc_network.vpc.id
  description = "Security group для приватных сервисов проекта AppWebBack"

  dynamic "ingress" {
    for_each = var.rules-app-web-back-ingress
    content {
      description    = ingress.value.description
      protocol       = ingress.value.protocol
      from_port      = ingress.value.from_port
      to_port        = ingress.value.to_port
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.rules-app-web-back-egress
    content {
      description    = egress.value.description
      protocol       = egress.value.protocol
      from_port      = egress.value.from_port
      to_port        = egress.value.to_port
      v4_cidr_blocks = egress.value.v4_cidr_blocks
    }
  }
}
