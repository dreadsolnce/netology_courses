# Создание новой сети
# ---------------------------------------------------------------------

resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

resource "yandex_vpc_subnet" "vpc_subnet" {
  name           = var.vpc_subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.cidr[0]]
}

# Создание виртуальной машины
#---------------------------------------------------------------------

data "yandex_compute_image" "image-vm" {
  family = var.image-vm-family
}

resource "yandex_compute_instance" "web" {
  # name        = join("", [var.nameVMWeb, "-${count.index+1}"])
  name        = var.name-vm
  zone        = var.zone
  platform_id = var.type-vm
  hostname    = var.name-vm
  service_account_id = yandex_iam_service_account.docker.id

  resources {
    cores         = var.resourcesVM.cores
    memory        = var.resourcesVM.memory
    core_fraction = var.resourcesVM.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image-vm.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_subnet.id
    security_group_ids = [yandex_vpc_security_group.security_group_production.id]
    nat = true
  }

  metadata = {
    serial-port-enable = 1
    # Через файл открытого ключа pub на локальной машине
    ssh-keys           = "ubuntu:${local.ssh_pub_key}"
    # Установка дополнительного ПО
    user-data          = data.template_file.cloudinit.rendered
  }

  depends_on = [
    yandex_container_registry_iam_binding.docker
  ]
}

#----------------Установка дополнительного ПО с помощью cloud-init------------------------------------------
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key               = local.ssh_pub_key
    packages                     = jsonencode(var.packages)
    yandex_container_registry_id = yandex_container_registry.kvl-registry.id
    # yandex_mdb_mysql_name        = yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn

    # Переменные приложения
    path-app                     = var.path-app
    # db-host                      = var.DB_HOST
    db-host                      = yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn
    db-user                      = var.DB_USER
    db-password                  = var.DB_PASSWORD
    db-name                      = var.DB_NAME

    # Данные для подключения к базе mysql которая крутится в docker container (для теста(ов))
    mysql-root-password         = var.MYSQL_ROOT_PASSWORD
    mysql-user                  = var.MYSQL_USER
    mysql-password              = var.MYSQL_PASSWORD
    mysql-database              = var.MYSQL_DATABASE
  }
}

##################CONTAINER REGISTRY#########################################################

#---------------Создание репозитория Container Registry----------------------------------------
resource "yandex_container_registry" "kvl-registry" {
  name = var.kvl-registry
  folder_id = var.target_folder_id
}

#---------------Создание сервисного аккаунта--------------------------------------------------
resource "yandex_iam_service_account" "docker" {
  name = var.docker
  folder_id = var.target_folder_id
}

#---------------Назначение роли сервисному аккаунту------------------------------------------
resource "yandex_resourcemanager_folder_iam_member" "role_registry" {
  for_each = { "role1" = "container-registry.images.puller", "role2" = "container-registry.images.pusher" }
  folder_id   = var.target_folder_id
  member      = "serviceAccount:${yandex_iam_service_account.docker.id}"
  role        = each.value
  depends_on = [
        yandex_container_registry.kvl-registry,
        yandex_iam_service_account.docker,
  ]
}

#--------------Назначение роли docker на уровне реестра kvl-registry--------------------------
resource "yandex_container_registry_iam_binding" "docker" {
  for_each    = { "role1" = "container-registry.images.puller", "role2" = "container-registry.images.pusher" }
  members     = ["serviceAccount:${yandex_iam_service_account.docker.id}"]
  registry_id = yandex_container_registry.kvl-registry.id
  # role        = "container-registry.images.puller"
  role        = each.value
  depends_on = [
        yandex_container_registry.kvl-registry,
        yandex_iam_service_account.docker,
  ]
}

#--------------Создание базы данных mysql ----------------------------------------------------
resource "yandex_mdb_mysql_database" "my_db" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = "animals"
}

resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = "test"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.vpc.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-ssd"
    disk_size          = 16
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.vpc_subnet.id
    # assign_public_ip   = true
  }
}

resource "yandex_mdb_mysql_user" "my_user" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = "animals"
  password   = "animalspwd"
  permission {
    database_name = yandex_mdb_mysql_database.my_db.name
    roles = ["ALL"]
  }
}