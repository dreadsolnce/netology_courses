output "Яндекс_Registry" {
  value = yandex_container_registry.registry.id
}

output "Общая_информация_по_мастер_нодам" {
  value = local.sorted_list_master_node
}

output "Общая_информация_по_bastion" {
  value = {
    name = var.settings_bastion.hostname
    network_private = var.settings_bastion.ipaddress
    network_public  = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  }
}

output "Абсолютный_путь" {
  value = {
    path    = path.module
    abspath = abspath(path.module)
  }
}

output "Основные_скрипты_запуска" {
  value = {
    file_kubespray      = "${abspath(path.module)}/conf/kubespray/kubespray.sh"
    file_prometheus     = "${abspath(path.module)}/conf/grafana/kube-prometheus.sh"
    file_app            = "${abspath(path.module)}/conf/app/app.sh"
  }
}
