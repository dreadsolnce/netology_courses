# Создание сети для проекта
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Создание подсетей
resource "yandex_vpc_subnet" "sunbets" {
  for_each = var.subnets

  name = "subnet-${each.key}"
  zone = each.value.zone
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [each.value.cidr]
}

# Создание трех vm для мастер нод кластера
data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "master-node" {
  for_each = var.settings_master_node

  name                  = each.key
  hostname              = each.key
  zone                  = each.value.zone
  platform_id           = var.platform

  allow_stopping_for_update = true # Останавливает vm без предупреждения при изменении конфигурации

  resources {
    cores                 = var.resources_master_nodes.cores
    memory                = var.resources_master_nodes.memory
    core_fraction         = var.resources_master_nodes.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.image_id
    }
  }

  network_interface {
    # subnet_id              = yandex_vpc_subnet.subnet[each.value.subnet].id
    subnet_id = yandex_vpc_subnet.sunbets[split("-", each.value.zone)[2]].id
    nat                    = each.value.nat
    ip_address             = each.value.ipaddress
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
  }
}

# Создание inventory файла для ansiblle
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      master-node = yandex_compute_instance.master-node
    }
  )
  filename = "${abspath(path.module)}/hosts.ini"
  file_permission = "0644"
}