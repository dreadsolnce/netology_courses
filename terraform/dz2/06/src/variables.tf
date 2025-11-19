###cloud vars
variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cloud_id" {
  type        = string
  default     = "b1gr160bk1vuruuer3om"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gdmpusv51ippn2psip"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

###my vars

variable "vm_web_name_os" {
  type = string
  default = "ubuntu-2004-lts"
  description = "Type of OS installed"
}

variable "vm_web_name_vm" {
  type = string
#  default = "netology-develop-platform-web"
  default = "web"
  description = "Virtual machine name"
}

variable "vm_web_type" {
  type = string
  default = "standard-v3"
  description = "Platform type"
}

variable "vm" {
  type = map(object( 
     { 
      cores = number
      memory = number
      core_fraction = number
     }
  ))
}

variable "metadata" {
  type = map(any)
}

#variable "vm_web_core" {
#  type = number
#  default = 2
#  description = "Number of virtual processors"
#}

#variable "vm_web_memory" {
#  type = number
#  default = 1
#  description = "Amount of memory"
#}

#variable "vm_web_core_fraction" {
#  type = number
#  default = 20
#  description = "CPU Power Ratio"
#}

###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCad7tWiE8y4PrK2pG4jmXGriccjUFyiC2jOo0xVAosqPiQfFYqoXlPdUpgoH+InQP2MiOnIK7iZTm/i5ZRlxkSibCm9GjyHXBBXvGk9rBPYtgMeF7YP3fqQlQ+DsVtoj6K/75Mw5n4ZkVYMapLO9SSTicTy8WI8UFd+X0EWa5FT0gJr4sHKDjqMv62E5iyUoX+JZIZAvi4rMiK518Mc11fkmI/AJQr5/kePkXaSgdRtHEqB7GoKyI7062ONNCENw5ww/C2LAnfac2z9wllgnLeqhTb7BJ+JOnATMmqMFUO/tnE6o5L/U5JwZlpJW2UJN2l8cNx2C33Hthrkrk12JdFauQgCamKHBQNOPkWr3fIjyO4u4VVN34mmvcaYPEg4gubmGL25r7OqJys0DfXK18vrr3sW5ws37iFvoGrLbGla12YtKATXkGjvXCoAHz05HsWJz8PC6YK25ydRYTFbs0METnhgp0YB9ElTYHDlhLBUmEgeU0cqE6C8kDt7+r5zG8= kvl@main"
#  description = "ssh-keygen -t ed25519"
#}
