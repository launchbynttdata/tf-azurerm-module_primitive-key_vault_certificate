# import

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.67 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~>2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_certificate_deployment_role_assignment"></a> [certificate\_deployment\_role\_assignment](#module\_certificate\_deployment\_role\_assignment) | terraform.registry.launch.nttdata.com/module_primitive/role_assignment/azurerm | ~> 1.0 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | terraform.registry.launch.nttdata.com/module_primitive/key_vault/azurerm | ~> 2.1 |
| <a name="module_key_vault_certificate"></a> [key\_vault\_certificate](#module\_key\_vault\_certificate) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_product_family"></a> [product\_family](#input\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"dso"` | no |
| <a name="input_product_service"></a> [product\_service](#input\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"kube"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment in which the resource should be provisioned like dev, qa, prod etc. | `string` | `"dev"` | no |
| <a name="input_environment_number"></a> [environment\_number](#input\_environment\_number) | The environment count for the respective environment. Defaults to 000. Increments in value of 1 | `string` | `"000"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which the infra needs to be provisioned | `string` | `"eastus"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object(<br>    {<br>      name       = string<br>      max_length = optional(number, 60)<br>    }<br>  ))</pre> | <pre>{<br>  "kv": {<br>    "max_length": 24,<br>    "name": "kv"<br>  },<br>  "msi": {<br>    "max_length": 60,<br>    "name": "msi"<br>  },<br>  "rg": {<br>    "max_length": 60,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_issuer_name"></a> [issuer\_name](#input\_issuer\_name) | name of the issuer to generate the certificate with. Use 'Self' for self-signed certificate | `string` | `"Self"` | no |
| <a name="input_key_properties"></a> [key\_properties](#input\_key\_properties) | options for the private key of the certificate | <pre>object({<br>    exportable = bool<br>    key_type   = string<br>    reuse_key  = bool<br>    curve      = optional(string)<br>    key_size   = optional(number)<br>  })</pre> | <pre>{<br>  "exportable": true,<br>  "key_size": 2048,<br>  "key_type": "RSA",<br>  "reuse_key": false<br>}</pre> | no |
| <a name="input_lifetime_action"></a> [lifetime\_action](#input\_lifetime\_action) | action to take when the certificate is about to expire | <pre>object({<br>    action = object({<br>      action_type = string<br>    })<br>    trigger = object({<br>      days_before_expiry  = optional(number)<br>      lifetime_percentage = optional(number)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_secret_properties"></a> [secret\_properties](#input\_secret\_properties) | properties of the underlying key vault secret | <pre>object({<br>    content_type = string<br>  })</pre> | <pre>{<br>  "content_type": "application/x-pkcs12"<br>}</pre> | no |
| <a name="input_x509_certificate_properties"></a> [x509\_certificate\_properties](#input\_x509\_certificate\_properties) | properties of the x509 certificate | <pre>object({<br>    key_usage          = list(string)<br>    extended_key_usage = optional(list(string))<br>    subject            = string<br>    validity_in_months = number<br>    subject_alternative_names = optional(object({<br>      dns_names = optional(list(string))<br>      emails    = optional(list(string))<br>      upns      = optional(list(string))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the Key vault | `map(string)` | `{}` | no |
| <a name="input_certificate_name"></a> [certificate\_name](#input\_certificate\_name) | Name of the certificate to import | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | n/a |
| <a name="output_access_policies_object_ids"></a> [access\_policies\_object\_ids](#output\_access\_policies\_object\_ids) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | n/a |
| <a name="output_certificate_name"></a> [certificate\_name](#output\_certificate\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
