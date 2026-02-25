locals {
  sa_key_file = file("~/keys/${var.auth_key}.json")
  sa_key_file_s3 = file("~/.aws/${var.ydb_key}")
  ssh_pub_key = file("~/.ssh/id_rsa.pub")
}
