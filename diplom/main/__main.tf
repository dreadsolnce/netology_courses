# Создание сети для проекта
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Создание приватных подсетей и одной публичной для VM БАСТИОН
resource "yandex_vpc_subnet" "sunbets" {
  for_each = var.subnets

  name            = "subnet-${each.key}"
  zone            = each.value.zone
  network_id      = yandex_vpc_network.vpc.id
  v4_cidr_blocks  = [each.value.cidr]
  route_table_id  = each.key != "public" ? yandex_vpc_route_table.rt.id : null
}

# 3. Создание подсети
resource "yandex_vpc_subnet" "test" {
  name           = "test"
  v4_cidr_blocks = ["10.0.0.0/24"] # Диапазон адресов [1]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id # Привязка к сети [1]
}

# Создание ключей ssh для доступа из bastion до vm
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Создание VM БАСТИОН, который будет обратным прокси (nginx) - единственная точка входа, а также будет шлюзом для доступа vm в облачную сеть
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
      type     = var.resources_bastion.type_disk
    }
  }

  network_interface {
    subnet_id               = yandex_vpc_subnet.sunbets["public"].id
    nat                     = var.settings_bastion.nat
    ip_address              = var.settings_bastion.ipaddress
    nat_ip_address = yandex_vpc_address.public_ip_static.external_ipv4_address[0].address
  }

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${file(var.ssh_public_key)}"            # Через файл открытого ключа pub на локальной машине
    user-data           = data.template_file.cloudinit-bastion.rendered   # Установка дополнительного ПО
  }
  # Создается только после того как создадутся мастер ноды
  depends_on = [
    yandex_compute_instance.master-node
  ]
}

# Настройки для vm бастион
data "template_file" "cloudinit-bastion" {
  template = file("./cloud-init-bastion.yml")
  # Переменные
  vars = {
    ssh_public_key            = file(var.ssh_public_key)
    ssh_private_key           = tls_private_key.key.private_key_pem

    packages                  = jsonencode(var.packages)

    db_host                   = var.db_host
    db_user                   = var.db_user
    db_password               = var.db_password
    db_name                   = var.db_name
    mysql_root_password       = var.mysql_root_password

    secret                    = var.secret
    token                     = var.token
    url                       = var.url
    username                  = var.username
    repo_github               = var.repo_github
    yc_cloud_id               = var.yc_cloud_id
    yc_folder_id              = var.yc_folder_id

    yandex_container_registry_id = yandex_container_registry.registry.id
    token_gitlab_agent        = var.token_gitlab_agent
    token_gitlab_runner       = var.token_gitlab_runner

    name_control_node         = local.sorted_list_master_node[0].name
    file_content              = templatefile("${path.module}/proxy.tftpl", {
        master-node           = local.sorted_list_master_node
        file_privkey          = fileexists(var.file_privkey) ? filebase64(var.file_privkey) : ""
        file_fullchain        = fileexists(var.file_fullchain) ? filebase64(var.file_fullchain) : ""
        file_chain            = fileexists(var.file_chain) ? filebase64(var.file_chain) : ""
    })
    file_ansible_hosts        = templatefile("${path.module}/hosts.tftpl", {
        master-node           = local.sorted_list_master_node
    })

    file_kubespray            = filebase64("${abspath(path.module)}/conf/kubespray/kubespray.sh")
    file_addons               = filebase64("${abspath(path.module)}/conf/kubespray/addons.yml")
    file_prometheus           = filebase64("${abspath(path.module)}/conf/grafana/kube-prometheus.sh")
    file_grafana_node_port    = filebase64("${abspath(path.module)}/conf/grafana/grafana-node-port.yml")
    file_app                  = filebase64("${abspath(path.module)}/conf/app/app.yml")
    file_base                 = filebase64("${abspath(path.module)}/conf/app/base/animals.sql")
    file_appsh                = filebase64("${abspath(path.module)}/conf/app/app.sh")
    file_secret_tmpl          = filebase64("${abspath(path.module)}/conf/app/mysqlsecret.yaml.tmpl")
    file_atlantis             = filebase64("${abspath(path.module)}/conf/atlantis/atlantis-install.sh")
    file_yandex_auth          = filebase64(var.auth_key_sa_yandex)
    file_auth_key_s3          = filebase64(var.auth_key_s3)
    file_ssh_public_key       = filebase64(var.ssh_public_key)
    file_terraformrc          = filebase64("${abspath(path.module)}/conf/terraform/.terraformrc")
    file_connect              = filebase64("${abspath(path.module)}/conf/gitlab/connect.sh")
    file_privkey              = fileexists(var.file_privkey) ? filebase64(var.file_privkey) : ""
    file_fullchain            = fileexists(var.file_fullchain) ? filebase64(var.file_fullchain) : ""
    file_chain                = fileexists(var.file_chain) ? filebase64(var.file_chain) : ""
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
      image_id  = data.yandex_compute_image.image.image_id
      size      = var.resources_master_nodes.disk_size
      type      = var.resources_master_nodes.type_disk
    }
  }

  network_interface {
    subnet_id               = yandex_vpc_subnet.sunbets[split("-", each.value.zone)[2]].id
    nat                     = each.value.nat
    ip_address              = each.value.ipaddress
  }

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  metadata = {
    # Доступ через файлы открытых ключей: локальная машина и VM БАСТИОН
    serial-port-enable  = 1
    ssh-keys            = "ubuntu:${file(var.ssh_public_key)}"
    user-data           = data.template_file.cloudinit-vm.rendered
  }
}

# Добавляем открытый ключ для доступа из VM БАСТИОН
data "template_file" "cloudinit-vm" {
  template                  = file("./cloud-init_vm.yml")
  # Переменные которые передаются в шаблон при первом запуске
  vars = {
    ssh_public_key_local          = file(var.ssh_public_key)
    ssh_public_key_bastion        = tls_private_key.key.public_key_openssh
  }
}

# Создаем отсортированный список master node, для того чтобы при создании файла hosts.ini из шаблона иметь доступ к счетчику (что бы сформировать запись etcd_member_name=etcd1, ...)
locals {
  sorted_list_master_node     = flatten([
  for k, v in yandex_compute_instance.master-node : {
      name              = v.name
      network_public    = v.network_interface[0]["nat_ip_address"]
      network_private   = v.network_interface[0]["ip_address"]
    }
  ])
}

# Создание inventory файла для ansiblle
resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      # master-node = yandex_compute_instance.master-node
      master-node   = local.sorted_list_master_node
    }
  )
  filename          = "${abspath(path.module)}/hosts.ini"
  file_permission   = "0644"
}

