locals {
  sa_key_file = file("~/keys/${var.auth_key}.json")
  ssh_pub_key = file("~/.ssh/id_rsa.pub")
}
