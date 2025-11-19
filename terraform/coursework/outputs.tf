output "yandex_container_registry_id" {
    value = yandex_container_registry.kvl-registry.id
}

output "name_fqdn_db" {
    value = yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn
}
