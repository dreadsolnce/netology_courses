# Группа безопасности для vm1 - public
resource "yandex_vpc_security_group" "sg-vm1-public" {
  name       = "instance-sg-vm1-public"
  network_id = yandex_vpc_network.vpc-netology.id

  # Разрешить весь трафик!
  egress {
    protocol       = "ANY"
    description    = "Allow all outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow all incoming traffic from private subnet"
    v4_cidr_blocks = ["192.168.20.0/24"]
  }
}

# # Группа безопасности для NAT-инстанса
# resource "yandex_vpc_security_group" "nat_sg" {
#   name       = "nat-instance-sg"
#   network_id = yandex_vpc_network.vpc.id
#
#   egress {
#     protocol       = "ANY"
#     description    = "Allow all outgoing traffic"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   ingress {
#     protocol       = "ANY"
#     description    = "Allow all incoming traffic from private subnet"
#     v4_cidr_blocks = ["192.168.20.0/24"]
#   }
# }
