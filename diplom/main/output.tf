output "Общая_информация_по_мастер_нодам" {
  value = local.sorted_list_master_node
}

output "Общая_информация_по_bastion" {
  value = {
    name = var.settings_bastion.hostname
    network_private = var.settings_bastion.ipaddress
    network_public  = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  }
}