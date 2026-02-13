# Таблица маршрутизации для приватной подсети
resource "yandex_vpc_route_table" "route-table" {
  name       = "rt-app-web-back"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.settings_nat.local_ip
  }
}
