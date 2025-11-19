###my vars

variable "vm_db_name_os" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Type of OS installed"
}

variable "vm_db_name_vm" {
  type = string
#  default = "netology-develop-platform-db"
  default = "db"
  description = "Virtual machine name"
}

variable "vm_db_type" {
  type = string
  default = "standard-v3"
  description = "Platform type"
}

#variable "vm_db_core" {
#  type = number
#  default = 2
#  description = "Number of virtual processors"
#}

#variable "vm_db_memory" {
#  type = number
#  default = 2  
#  description = "Amount of memory"
#}

#variable "vm_db_core_fraction" {
#  type = number
#  default = 20
#  description = "CPU Power Ratio"
#}
