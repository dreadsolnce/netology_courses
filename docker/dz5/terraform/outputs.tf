output my-output {
  value = [
    for key, instance in yandex_compute_instance.vm : {
      count      = key
      hostname  = instance.name
      public_ip = instance.network_interface[0].nat_ip_address
      fqdnname  = instance.fqdn
    }
  ]
}


  # value = { vm1 = [
	# 		yandex_compute_instance.vm[0].name,
	# 		yandex_compute_instance.vm[0].network_interface[0].nat_ip_address,
	# 		yandex_compute_instance.vm[0].fqdn
	# 	  ],
	#    vm2 = [
	# 		yandex_compute_instance.vm[1].name,
	# 		yandex_compute_instance.vm[1].network_interface[0].nat_ip_address,
	# 		yandex_compute_instance.vm[1].fqdn
	# 	  ]
    #    vm3 = [
	# 		yandex_compute_instance.vm[2].name,
	# 		yandex_compute_instance.vm[2].network_interface[0].nat_ip_address,
	# 		yandex_compute_instance.vm[2].fqdn
	# 	  ]
	#  }
