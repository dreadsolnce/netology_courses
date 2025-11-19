# data "yandex_compute_image" "ubuntu" {
#   family = "ubuntu-2004-lts"
# }

# Создание вторых двух виртуальных машин
resource "yandex_compute_instance" "db" {
  for_each    = { 0 = "db1", 1 = "db2" }

  name        = var.resourcesVMDb[each.key].vm_name
  zone        = var.default_zone
  platform_id = "standard-v3"
  hostname    = var.resourcesVMDb[each.key].vm_name

  resources {
    cores = var.resourcesVMDb[each.key].cpu
    memory = var.resourcesVMDb[each.key].ram
    core_fraction = var.resourcesVMDb[each.key].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.resourcesVMDb[each.key].disk_volume
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
