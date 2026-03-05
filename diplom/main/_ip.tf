# Резервируем статический публичный IP-адрес в зоне ru-central1-a для applications балансировщика
resource "yandex_vpc_address" "public_ip_static" {
  name = "public_ip_static"
  deletion_protection = true
  external_ipv4_address {
    zone_id = var.default-zone
  }
}