# Создание inventory файла для ansiblle

resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.web,
      dbservers = yandex_compute_instance.db,
      storageservers = yandex_compute_instance.storage
    }
  )

  filename = "${abspath(path.module)}/hosts.ini"
}

