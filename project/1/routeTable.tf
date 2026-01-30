# Таблица маршрутизации для приватной подсети
resource "yandex_vpc_route_table" "rtNat" {
  name       = "rt-nat"
  network_id = yandex_vpc_network.vpc-netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat_instance.network_interface.0.ip_address
  }
}
