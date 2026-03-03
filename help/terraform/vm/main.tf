# Создание ключей ssh для доступа из bastion до vm
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

 # 1. Создаем виртуальную сеть
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

# 2. Создаем подсеть (без нее ВМ не запустится)
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# 3. Выбираем последний образ Ubuntu 22.04 LTS
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# 4. Описываем саму виртуальную машину
resource "yandex_compute_instance" "vm-1" {
  name = "simple-vm"
  platform_id           = var.platform

  resources {
    cores = 2 # Ядра
    memory = 2 # ГБ оперативной памяти
    core_fraction = 100 # Экономия: гарантированная доля CPU (20%, 50%, 100%)
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20 # Размер диска в ГБ
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true # Включаем публичный IP адрес
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${trimspace(local.ssh_pub_key)}\nubuntu:${trimspace(tls_private_key.key.public_key_openssh)}"
    user-data          = data.template_file.cloudinit.rendered
  }

  # user-data          = data.template_file.cloudinit.rendered
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key = local.ssh_pub_key
    ssh_public_key_bastion = tls_private_key.key.public_key_openssh
  }
}