# Создание виртуальной машины
#---------------------------------------------------------------------

data "yandex_compute_image" "image-vm" {
  family = var.image-vm-family
}

resource "yandex_compute_instance" "vm-public" {
  # name        = join("", [var.nameVMWeb, "-${count.index+1}"])
  name        = var.name-vm[0]
  zone        = var.zone[0]
  platform_id = var.type-vm
  hostname    = var.name-vm[0]
#   allow_stopping_for_update = true # Добавьте эту строку

  resources {
    cores         = var.resourcesVM.cores
    memory        = var.resourcesVM.memory
    core_fraction = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image-vm.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_subnet_public.id
    security_group_ids = [yandex_vpc_security_group.sg-public.id]
    nat = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys = "ubuntu:${local.ssh_pub_key}"
  }
}

resource "yandex_compute_instance" "vm-private" {
  # name        = join("", [var.nameVMWeb, "-${count.index+1}"])
  name        = var.name-vm[1]
  zone        = var.zone[1
]
  platform_id = var.type-vm
  hostname    = var.name-vm[1]
#   allow_stopping_for_update = true # Добавьте эту строку

  resources {
    cores         = var.resourcesVM.cores
    memory        = var.resourcesVM.memory
    core_fraction = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image-vm.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_subnet_private.id
    security_group_ids = [yandex_vpc_security_group.sg-private.id]
#    nat = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys = "ubuntu:${local.ssh_pub_key}"
  }
}
