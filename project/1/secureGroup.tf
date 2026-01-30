# Группа безопасности для vm1 - public
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


# Группа безопасности для vm1 - private
resource "yandex_vpc_security_group" "sg-private" {
  name       = "private"
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

