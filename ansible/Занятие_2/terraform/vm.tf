data "yandex_compute_image" "ubuntu" {
#  family = "ubuntu-2004-lts"
  family = "fedora-35"
}

# Создание первых двух виртуальных машин
resource "yandex_compute_instance" "web" {
  count       = 1
  # name        = "${var.nameVMWeb}-${count.index+1}"
  name        = join("", [var.nameVMWeb, "-${count.index+1}"])
  zone        = var.default_zone
  platform_id = "standard-v3"
  hostname    = join("", [var.nameVMWeb, "-${count.index+1}"])

  resources {
    cores = var.resourcesVMWeb.cores
    memory = var.resourcesVMWeb.memory
    core_fraction = var.resourcesVMWeb.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys = "ubuntu:${local.ssh_pub_key}"
    # Через локальную переменную с текстом открытого ключа pub
    # ssh-keys           = local.ssh_key
  }
}

