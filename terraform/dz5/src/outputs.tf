output "yandex_vpc_subnet_output_main" {
    value = module.create_vpc.yandex_vpc_subnet_output
}

output "testIP_1" {
    value = join("/",tolist(["192.168.0.1", "32"]))
}

output "testIP_2" {
    value = [ for i in var.testIP_2: i ]
}

output "testIP_3" {
    value = {for_each = toset(var.testIP_2)}
}
