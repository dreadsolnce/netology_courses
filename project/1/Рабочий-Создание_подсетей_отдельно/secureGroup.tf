# Группа безопасности для сети - public
resource "yandex_vpc_security_group" "sg-public" {
  name       = "public"
  network_id = yandex_vpc_network.vpc-netology.id

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

# Группа безопасности сети - private
resource "yandex_vpc_security_group" "sg-private" {
  name       = "private"
  network_id = yandex_vpc_network.vpc-netology.id
  description = "Security group для внутренних сервисов приложений (виртуальная машина back)"

  # Разрешить весь исходящий трафик!
  # egress {
  #   protocol       = "ANY"
  #   description    = "Allow all outgoing traffic"
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }
  # Разрешить только http
  egress {
    protocol       = "tcp"
    description    = "Allow http"
    from_port      = 80
    to_port        = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешить весь входящий трафик!
  # ingress {
  #   protocol       = "ANY"
  #   description    = "Allow all incoming traffic"
  #   v4_cidr_blocks = ["0.0.0.0/0"]
  # }
  # Разрешить подключение по ssh с front сервера!
  ingress {
    protocol    = "TCP"
    description = "Allow incoming traffic ssh"
    from_port   = 22
    to_port     = 22
    v4_cidr_blocks = ["192.168.10.11/32"]
  }
  ingress {
    protocol    = "ICMP"
    description = "Allow ping"
    v4_cidr_blocks = ["192.168.10.0/24"]
  }
}