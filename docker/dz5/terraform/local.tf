locals {
  environment = "production"
  ssh_pub_key = file("~/.ssh/id_rsa.pub")
}