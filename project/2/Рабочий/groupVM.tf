# Создание группы экземпляров ---
resource "yandex_compute_instance_group" "group-vm" {
  name      = "group-vm"
  folder_id = var.folder_id
  service_account_id = yandex_iam_service_account.service_account.id

  # Политика масштабирования: фиксированное количество ВМ
  scale_policy {
    fixed_scale {
      size = 1 # <-- Здесь задается количество ВМ
    }
  }

  # Политика развертывания: как обновлять экземпляры
  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }

  instance_template {
    platform_id = var.platformVM

    resources {
      cores         = var.resourcesVM.cores
      memory        = var.resourcesVM.memory
      core_fraction = var.resourcesVM.core_fraction
    }

    boot_disk {
      initialize_params {
        image_id = var.imageIDVMTemplate
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc-netology.id
      subnet_ids = [yandex_vpc_subnet.subnet["public"].id]
      nat = true
    }

    metadata = {
      serial-port-enable = 1
      # Через файл открытого ключа pub на локальной машине
      ssh-keys           = "ubuntu:${local.ssh_pub_key}"
      # Установка дополнительного ПО
      user-data          = data.template_file.cloudinit.rendered
    }
  }
  # Политика размещения: все ВМ в одной зоне
  allocation_policy {
    zones = [var.instance_zone]
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.groupvm-role
  ]
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key = local.ssh_pub_key
    url_for_jpg = "https://${yandex_storage_bucket.image_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.picture.key}"
  }
}
