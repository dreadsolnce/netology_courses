<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.156.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.develop](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Используемая сеть. Обязательный параметр, т.к. не указано значение по умолчанию | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Название сети | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Используемая зона | `string` | `"ru-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_yandex_vpc_network_id"></a> [yandex\_vpc\_network\_id](#output\_yandex\_vpc\_network\_id) | n/a |
| <a name="output_yandex_vpc_subnet_develop_id"></a> [yandex\_vpc\_subnet\_develop\_id](#output\_yandex\_vpc\_subnet\_develop\_id) | n/a |
| <a name="output_yandex_vpc_subnet_output"></a> [yandex\_vpc\_subnet\_output](#output\_yandex\_vpc\_subnet\_output) | n/a |
<!-- END_TF_DOCS -->