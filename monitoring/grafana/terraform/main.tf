# Создание новой сети
# ---------------------------------------------------------------------

resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

resource "yandex_vpc_subnet" "vpc_subnet" {
  name           = var.vpc_subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.cidr_net]
}

# Создание виртуальных машин
# ---------------------------------------------------------------------
data "yandex_compute_image" "nameOS" {
  image_id = var.imageID
}

resource "yandex_compute_instance" "vm" {
  # Функция toset преобразует список в набор строк
  for_each = toset(var.instance_name)
  # name = each.key == "teamcity-server" ? "teamcity-server" : "teamcity-agent"
  name = each.key
  # hostname = each.key == "teamcity-server" ? "teamcity-server" : "teamcity-agent"
  hostname = each.key
  zone        = var.zone
  platform_id = var.type-vm

  resources {
    cores         = var.resourcesVM.cores
    memory        = var.resourcesVM.memory
    core_fraction = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nameOS.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_subnet.id
    nat = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_pub_key}"
  }
}
