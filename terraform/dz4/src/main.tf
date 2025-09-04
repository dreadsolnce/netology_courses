# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }
#
# resource "yandex_vpc_subnet" "develop_a" {
#   name           = var.subnet_name[0]
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }

# Вызов локального модуля создания сети и подсети
module "create_vpc" {
    source       = "./vpc"
    env_name     = "develop"
    zone         = "ru-central1-a"
    cidr         = "10.0.1.0/24"
}

# # Отдельный ресурс подсети зоны b (не знаю нужен ли для домашнего задания)
# resource "yandex_vpc_subnet" "develop_b" {
#   name           = var.subnet_name[1]
#   zone           = var.subnet_zone[1]
# #   network_id     = yandex_vpc_network.develop.id
#   network_id     = module.create_vpc.yandex_vpc_network_id
#   v4_cidr_blocks = var.cidr_develop_b
# }

module "marketing-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.env_name[0]
#   network_id     = yandex_vpc_network.develop.id
  network_id     = module.create_vpc.yandex_vpc_network_id
  subnet_zones   = var.subnet_zone
#   subnet_ids     = [module.create_vpc.yandex_vpc_subnet_develop_a_id,yandex_vpc_subnet.develop_b.id]
  subnet_ids     = [module.create_vpc.yandex_vpc_subnet_develop_id]
  instance_name  = "webs"
  instance_count = 1
  image_family   = var.name_os
  public_ip      = var.public_ip_address

  labels = {
    owner   = "kolchin_vladimir",
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }
}

module "analytics-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = var.env_name[1]
#   network_id     = yandex_vpc_network.develop.id
  network_id     = module.create_vpc.yandex_vpc_network_id
  subnet_zones   = var.subnet_zone
#   subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  subnet_ids     = [module.create_vpc.yandex_vpc_subnet_develop_id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = var.name_os
  public_ip      = var.public_ip_address

  labels = {
    owner   = "kolchin_vladimir",
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars     = {
       ssh_public_key = file(var.vms_ssh_root_key)
       packages       = jsonencode(var.packages)
      }
}


