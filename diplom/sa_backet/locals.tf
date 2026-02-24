locals {
  ssh_pub_key = file("~/.ssh/id_rsa.pub")
  sa_key_file = file("~/keys/authorized_key.json")
}
