# Создание виртуальной машины NAT (для доступа из внутренней сети в интернет)
resource "yandex_compute_instance" "nat" {
  name                  = var.settings_nat.name
  hostname              = var.settings_nat.name
  zone                  = var.settings_nat.zone
  platform_id           = var.platform_vm

  allow_stopping_for_update = true # Останавливает vm без предупреждения при изменении конфигурации

  resources {
    cores                 = var.resources_vm.cores
    memory                = var.resources_vm.memory
    core_fraction         = var.resources_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_nat
    }
  }

  network_interface {
    subnet_id              = yandex_vpc_subnet.subnet[var.settings_nat.subnet].id
    # security_group_ids     = [yandex_vpc_security_group.sg-public.id]
    ip_address             = var.settings_nat.local_ip
    nat                    = var.settings_nat.public_ip
    security_group_ids     = [yandex_vpc_security_group.sg-app-web-back-public.id]
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}