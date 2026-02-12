# Создание виртуальной машины NAT
resource "yandex_compute_instance" "nat" {
  name                  = var.settingsVmNAT.name
  hostname              = var.settingsVmNAT.name
  zone                  = var.settingsVmNAT.zone
  platform_id           = var.platformVM

  allow_stopping_for_update = true # Останавливает vm без предупреждения при изменении конфигурации

  resources {
    cores                 = var.resourcesVM.cores
    memory                = var.resourcesVM.memory
    core_fraction         = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.imageNAT
    }
  }

  network_interface {
    subnet_id              = yandex_vpc_subnet.subnet-public[var.settingsVmNAT.subnet].id
    security_group_ids     = [yandex_vpc_security_group.sg-public.id]
    ip_address             = var.settingsVmNAT.ipaddress
    nat                    = var.settingsVmNAT.nat
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}