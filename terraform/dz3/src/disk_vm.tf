resource "yandex_compute_disk" "disk" {  
  count = 3
  name = "disk-${count.index+1}"  
  type = "network-hdd"  
  zone = var.default_zone  
  size = 1  
  block_size = 4096 
}  

# Создание одиночной виртуальной машины
resource "yandex_compute_instance" "storage" {
  # name        = join("", [var.nameVMWeb, "-${count.index+1}"])
  name        = "storage"
  zone        = var.default_zone
  platform_id = "standard-v3"
  hostname    = "storage"

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

  dynamic secondary_disk {
    for_each = yandex_compute_disk.disk
    content {
#      disk_id = yandex_compute_disk.disk[secondary_disk.name]
      disk_id = secondary_disk.value["id"]
    }
  }
}

