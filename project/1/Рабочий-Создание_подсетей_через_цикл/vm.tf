# Создание виртуальной машины
#---------------------------------------------------------------------
# Создание виртуальных машин : front, back
data "yandex_compute_image" "imageOS" {
  family = var.imageVM
}

resource "yandex_compute_instance" "vm" {
  for_each = var.settingsVM

  name                  = each.key
  hostname              = each.key
  zone                  = each.value.zone
  platform_id           = var.platformVM

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
    subnet_id              = yandex_vpc_subnet.subnet[each.value.subnet].id
    security_group_ids     = each.key == "back" ? [yandex_vpc_security_group.sg-private.id] : [yandex_vpc_security_group.sg-public.id]
    nat                    = each.value.nat
    ip_address             = each.value.ipaddress
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}

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
    subnet_id              = yandex_vpc_subnet.subnet[var.settingsVmNAT.subnet].id
    security_group_ids     = [yandex_vpc_security_group.sg-public.id]
    ip_address             = var.settingsVmNAT.ipaddress
    nat                    = var.settingsVmNAT.nat
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}