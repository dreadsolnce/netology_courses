# Создание виртуальной машины
#---------------------------------------------------------------------
# Создание виртуальных машин : front, back
data "yandex_compute_image" "imageOS" {
  family = var.image_vm
}

resource "yandex_compute_instance" "app-web-back" {
  for_each = var.settings_vm

  name                  = each.key
  hostname              = each.key
  zone                  = each.value.zone
  platform_id           = var.platform_vm

  allow_stopping_for_update = true # Останавливает vm без предупреждения при изменении конфигурации

  resources {
    cores                 = var.resources_vm.cores
    memory                = var.resources_vm.memory
    core_fraction         = var.resources_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.imageOS.image_id
    }
  }

  network_interface {
    subnet_id              = yandex_vpc_subnet.subnet[each.value.subnet].id
    ip_address             = each.value.local_ip
    nat                    = each.value.public_ip
    security_group_ids     = strcontains(each.value.subnet, "private") ? [yandex_vpc_security_group.sg-app-web-back-private.id] : [yandex_vpc_security_group.sg-app-web-back-public.id]
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${local.ssh_pub_key}"    # Через файл открытого ключа pub на локальной машине
    user-data = templatefile("${path.module}/cloud-init-vm.yml", {
      ssh_public_key      = local.ssh_pub_key
      packages            = jsonencode(var.packages)
      html_text           = each.key
    })
  }
}
