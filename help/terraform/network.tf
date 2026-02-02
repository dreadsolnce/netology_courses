resource "yandex_vpc_network" "vpc-netology" {
  name = var.vpc_name == null ? "unknown" : var.vpc_name
}

output "outVpc" {
  value = { 
	id_сети   = yandex_vpc_network.vpc-netology.id
	name_сети = yandex_vpc_network.vpc-netology.name
  }
  description = "Информация о сети"  
}

variable "vpc_name" {
	type        = string
	description = "Название сети (vpc)"
}
