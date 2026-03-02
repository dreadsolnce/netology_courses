# Создание сети для проекта
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Создание приватных подсетей
resource "yandex_vpc_subnet" "sunbets" {
  for_each = var.subnets

  name = "subnet-${each.key}"
  zone = each.value.zone
  network_id = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [each.value.cidr]
  # route_table_id = yandex_vpc_route_table.rt.id
  route_table_id = each.key != "public" ? yandex_vpc_route_table.rt.id : null
}

# Создание vm бастион, который будет обратным прокси (nginx) - единственная точка входа, а также будет шлюзом для доступа vm в облачную сеть
resource "yandex_compute_instance" "bastion" {
  name        = var.settings_bastion.hostname
  hostname    = var.settings_bastion.hostname
  zone        = var.settings_bastion.zone
  platform_id = var.platform

  allow_stopping_for_update = true

  resources {
    cores                 = var.resources_bastion.cores
    memory                = var.resources_bastion.memory
    core_fraction         = var.resources_bastion.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_bastion
      size     = var.resources_bastion.disk_size # Размер в ГБ
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.sunbets["public"].id
    nat                    = var.settings_bastion.nat
    ip_address             = var.settings_bastion.ipaddress
  }

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys            = <<EOT
      "ubuntu:${local.ssh_pub_key}"
      "ubuntu:${local.ssh_pub_key_bastion}"
      "ubuntu:${local.ssh_priv_key_bastion}"
    EOT
    
    # Установка дополнительного ПО
    user-data          = data.template_file.cloudinit-bastion.rendered
  }

  depends_on = [
    yandex_compute_instance.master-node
  ]
}

# Настройки для vm бастион
data "template_file" "cloudinit-bastion" {
  template = file("./cloud-init-bastion.yml")
  vars = {
    ssh_public_key = local.ssh_pub_key
    packages = jsonencode(var.packages)
    file_content = templatefile("${path.module}/proxy.tftpl", {
        master-node = local.sorted_list_master_node
    })
    file_ansible_hosts = templatefile("${path.module}/hosts.tftpl", {
        master-node = local.sorted_list_master_node
    })
    file_kubespray = filebase64("${path.module}/kubespray.sh")
    file_addons    = filebase64("${path.module}/addons.yml")
  }
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
      size     = 15 # Размер в ГБ
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.sunbets[split("-", each.value.zone)[2]].id
    nat                    = each.value.nat
    ip_address             = each.value.ipaddress
  }

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = <<EOT
      "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
      "ubuntu:${local.ssh_pub_key_bastion}"
    EOT
    # user-data          = data.template_file.cloudinit-node.rendered
  }
}

# data "template_file" "cloudinit-node" {
#   template = file("./cloud-init-node.yml")
#   vars = {
#     ssh_public_key = local.ssh_pub_key
#     packages = jsonencode(var.packages)
#     file_content = templatefile("${path.module}/proxy.tftpl", {
#         master-node = local.sorted_list_master_node
#     })
#     file_ansible_hosts = templatefile("${path.module}/hosts.tftpl", {
#         master-node = local.sorted_list_master_node
#     })
#     file_kubespray = filebase64("${path.module}/kubespray.sh")
#     file_addons    = filebase64("${path.module}/addons.yml")
#   }
# }

# Создаем отсортированный список master node, для того чтобы при создании файла hosts.ini из шаблона иметь доступ к счетчику (что бы сформировать запись etcd_member_name=etcd1, ...)
locals {
  sorted_list_master_node     = flatten([
  for k, v in yandex_compute_instance.master-node : {
      name            = v.name
      network_public  = v.network_interface[0]["nat_ip_address"]
      network_private = v.network_interface[0]["ip_address"]
    }
  ])
}

# Создание inventory файла для ansiblle
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      # master-node = yandex_compute_instance.master-node
      master-node = local.sorted_list_master_node
    }
  )
  filename = "${abspath(path.module)}/hosts.ini"
  file_permission = "0644"
}

