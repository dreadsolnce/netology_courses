output my-output {
  value = [
    for key, instance in yandex_compute_instance.vm : {
      count      = key
      hostname  = instance.name
      public_ip = instance.network_interface[0].nat_ip_address
      fqdnname  = instance.fqdn
      connect_nexus = key == "nexus" ? "${instance.network_interface[0].nat_ip_address}:8081" : null
      connect_server = key == "teamcity-server" ? "${instance.network_interface[0].nat_ip_address}:8111" : null
    }
  ]
}

