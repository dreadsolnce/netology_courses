output my-output {
 value = { vm1 = [
			yandex_compute_instance.web[0].name,
			yandex_compute_instance.web[0].network_interface[0].nat_ip_address,
			yandex_compute_instance.web[0].fqdn
		  ],
	   vm2 = [
			yandex_compute_instance.web[1].name,
			yandex_compute_instance.web[1].network_interface[0].nat_ip_address,
			yandex_compute_instance.web[1].fqdn
		  ]
       vm3 = [
			yandex_compute_instance.web[2].name,
			yandex_compute_instance.web[2].network_interface[0].nat_ip_address,
			yandex_compute_instance.web[2].fqdn
		  ]
	 }
}
