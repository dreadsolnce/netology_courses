# Создание виртуальной машины
#---------------------------------------------------------------------
# Создание виртуальных машин : front, back, nat
data "yandex_compute_image" "imageOS" {
  family = var.imageVM
}

resource "yandex_compute_instance" "vm" {
  for_each = { 0 = "front", 1 = "back"}

  name                  = var.settingsVM[each.key].vmNAME
  zone                  = var.settingsVM[each.key].zoneVM
  platform_id           = var.type-vm
  hostname              = var.settingsVM[each.key].vmNAME

  allow_stopping_for_update = true # Останавливает vm без предупреждения при изменении конфигурации

  resources {
    cores                 = var.resourcesVM.cores
    memory                = var.resourcesVM.memory
    core_fraction         = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.imageOS.image_id
    }
  }

  network_interface {
    subnet_id              = each.value == "back" ? yandex_vpc_subnet.vpc_subnet_private.id : yandex_vpc_subnet.vpc_subnet_public.id
    security_group_ids     = each.value == "back" ? [yandex_vpc_security_group.sg-private.id] : [yandex_vpc_security_group.sg-public.id]
    nat                    = var.settingsVM[each.key].typeNAT
    ip_address             = var.settingsVM[each.key].ipaddress
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}

resource "yandex_compute_instance" "vm-nat" {
  name                  = var.settingsVM[2].vmNAME
  zone                  = var.settingsVM[2].zoneVM
  platform_id           = var.type-vm
  hostname              = var.settingsVM[2].vmNAME

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
    subnet_id              = yandex_vpc_subnet.vpc_subnet_public.id
    security_group_ids     = [yandex_vpc_security_group.sg-public.id]
    nat                    = var.settingsVM[2].typeNAT
    ip_address             = var.settingsVM[2].ipaddress
  }
}