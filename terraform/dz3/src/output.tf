output пример_имя_первой_vm {
    value = { val1 = [
			yandex_compute_instance.web[0].name,
			]
        }
    }

output пример_имя_первой_и_второй_vm {
        value = [ { name = yandex_compute_instance.web[0].name }, { name = yandex_compute_instance.web[1].name} ]
        }

output ВЫВОД_WEB {
    value = [
            for key, value in yandex_compute_instance.web:
                {key = key, name = value.name, id = value.id, fqdn = value.fqdn}
        ]
    }

output ВЫВОД_DB {
    value = [
            for key, value in yandex_compute_instance.db:
                {key = key, name = value.name, id = value.id, fqdn = value.fqdn}
        ]
    }
