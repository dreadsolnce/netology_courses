# Создание сети для проекта
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

# Описание
# Функция flatten создает плоский список.
# В первом цикле мы проходим сначала по паре ключ значение, где ключ равен: k = "project-1", а значение равно словарь:
# v = "subnet-project-1-public-a" = { name = "public-project-1-a" , zone = "ru-central1-a" ...}
# Вторым циклом мы проходимся по словарю из v. где ключ k1 = subnet-project-1-public-a, а значение равно
# v1 = { name = "public-project-1-a" , zone = "ru-central1-a" }
# В итоге мы получаем список из словарей см. output

locals {
  flattened_subnets_map = flatten([var.subnets])
  flattened_subnets     = flatten([
    for k, v in var.subnets : [
      for k1, v1 in v : {
        test        = "${k}-${k1}"
        name        = v1.name
        zone        = v1.zone
        cidr        = v1.cidr
        description = v1.description
      }
    ]
  ])
}

resource  "yandex_vpc_subnet" "subnet" {
  for_each = { for k in local.flattened_subnets: k.name => k  }
  network_id     = yandex_vpc_network.vpc.id
  name           = each.key
  zone           = each.value.zone
  v4_cidr_blocks = each.value.cidr
  description    = each.value.description
}




