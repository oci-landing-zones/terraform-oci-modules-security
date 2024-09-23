## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_cloud_guard_cloud_guard_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_cloud_guard_configuration) | resource |
| [oci_cloud_guard_security_recipe.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_security_recipe) | resource |
| [oci_cloud_guard_security_zone.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_security_zone) | resource |
| [oci_cloud_guard_cloud_guard_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_cloud_guard_configuration) | data source |
| [oci_cloud_guard_security_policies.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_security_policies) | data source |
| [oci_identity_regions.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | <pre>map(object({<br>    id = string # the compartment OCID<br>  }))</pre> | `null` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable module output. | `bool` | `true` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"security-zones"` | no |
| <a name="input_security_zones_configuration"></a> [security\_zones\_configuration](#input\_security\_zones\_configuration) | Security Zones configuration. | <pre>object({<br>    default_cis_level = optional(string) # The default CIS level for all recipes with an unspecified cis_level. Valid values: "1" and "2". Default: "1"<br>    default_security_policies_ocids = optional(list(string)) # The list of default Security Zone policies OCIDs for all recipes with an unspecified security_policies_ocids. These are merged with CIS Security Zone policies driven off cis_level.<br>    default_defined_tags = optional(map(string))<br>    default_freeform_tags = optional(map(string))<br>    reporting_region = optional(string) # the reporting region.<br>    self_manage_resources = optional(bool) # whether Oracle managed resources are created by customers. Default: false.<br>    enable_obp_checks = optional(bool) # Checks whether the user can deploy Security Zone resources in the root compartment. Default: true.<br><br>    recipes = optional(map(object({<br>      name = string<br>      compartment_id = string # the compartment where the Security Zone Recipe is created. It can be either the compartment OCID or a reference (a key) to the compartment OCID.<br>      description = optional(string)<br>      cis_level = optional(string) # Valid values: "1" and "2". Default: "1"<br>      security_policies_ocids = optional(list(string)) # List of default Security Zone policies OCIDs that are merged with CIS Security Zone policies. These are merged with CIS Security Zone policies driven off cis_level.<br>      defined_tags = optional(map(string))<br>      freeform_tags = optional(map(string))<br>    })))<br><br>    security_zones = map(object({<br>      name = string # The Security Zone name.<br>      compartment_id = string # The Security Zone compartment. It can be either the compartment OCID or a reference (a key) to the compartment OCID. Any existing Cloud Guard target for this compartment is replaced with the security zone. The security zone includes the default Oracle-managed configuration and activity detector recipes in Cloud Guard, and also scans resources in the zone for policy violations.<br>      recipe_key = string # The recipe key in recipes attribute.<br>      description = optional(string) # The security zone description.<br>      defined_tags = optional(map(string))<br>      freeform_tags = optional(map(string))<br>    })) <br>  })</pre> | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy OCID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_guard_config_status_before_apply"></a> [cloud\_guard\_config\_status\_before\_apply](#output\_cloud\_guard\_config\_status\_before\_apply) | n/a |
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Cloud Guard configuration information. |
| <a name="output_recipes"></a> [recipes](#output\_recipes) | The security zones recipes. |
| <a name="output_security_zones"></a> [security\_zones](#output\_security\_zones) | The security zones. |
