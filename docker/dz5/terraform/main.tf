# Создание сети

# ***Создание новой сети***
# ---------------------------------------------------------------------
resource "yandex_vpc_network" "net" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
  description    = "Основная сеть для развертывания кластера docker-swarm"
  labels         = {
    environment: local.environment,
    managed-by: "terraform"
  }
}

# ***Создание новой подсети в сети my-net***
# ---------------------------------------------------------------------
resource "yandex_vpc_subnet" "subnet" {
  name           = var.vpc_name_subnet
  zone           = var.zone[0]
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = [var.cidr[0]]
  description    = "Подсеть сети mynet для проекта docker-swarm"
  labels         = {
    environment: local.environment,
    managed-by: "terraform"
  }
}

# ***Подключение (создание ресурса) правил фильтрации сетевого трафика***
#--------------------------------------------------------------------------
resource "yandex_vpc_security_group" "sec-group-production" {
  name        = "sec-group-${local.environment}"
  network_id  = yandex_vpc_network.net.id
  folder_id   = var.folder_id
  description = "Сетевые правила - Группа безопасности"
  labels      = {
    environment: local.environment,
    managed-by:  "terraform",
    description: "sec-group_for_net"
  }

  # Генерирует набор "ingress" части ресурса (resource "yandex_vpc_security_group") на основе данных из списка или карт
  dynamic "ingress" {
    for_each = var.sec_group_mynet_in
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.sec_group_mynet_out
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}

# ***Создание новых VM***
# ---------------------------------------------------------------------
data "yandex_compute_image" "nameOS" {
  # family = "ubuntu-2004-lts"
  image_id = var.imageID
}

resource "yandex_compute_instance" "vm" {
  count       = var.countVM
  name = count.index == 0 ? "control-${var.nameVM}" : join("", ["managed-",var.nameVM, count.index])
  hostname = count.index == 0 ? "control-${var.nameVM}" : join("", ["managed-",var.nameVM, count.index])
  zone        = var.zone[0]
  platform_id = var.platformID

  resources {
    cores = var.resourcesVM.cores
    memory = var.resourcesVM.memory
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
    subnet_id          = yandex_vpc_subnet.subnet.id
    security_group_ids = [yandex_vpc_security_group.sec-group-production.id]
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys = "ubuntu:${local.ssh_pub_key}"
  }
}

resource "null_resource" "hosts_provision" {
  depends_on = [yandex_compute_instance.vm]
   triggers = { always_run = timestamp() }
  # Создание inventory из файла шаблона
  provisioner "local-exec" {
    command = <<-EOA
      echo "${templatefile("hosts.tftpl", {hosts = yandex_compute_instance.vm[*]})}" > hosts.yml
      mv hosts.yml ../ansible
    EOA
  }
  # Пауза необходима так как виртуалки не сразу становятся доступными по ssh
  provisioner "local-exec" {
    command = "sleep 30"
  }
  # Запуск ansible-playbook
  provisioner "local-exec" {
    # command = "ansible-playbook -i ${abspath(path.module)}/hosts.yml ${abspath(path.module)}/playbook.yml"
    command = "ansible-playbook -i ../ansible/hosts.yml ../ansible/playbook.yml"
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }

}

