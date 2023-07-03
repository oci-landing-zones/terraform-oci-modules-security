## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) |  < 1.3.0 |

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
| [oci_cloud_guard_detector_recipe.activity_cloned](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_detector_recipe) | resource |
| [oci_cloud_guard_detector_recipe.configuration_cloned](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_detector_recipe) | resource |
| [oci_cloud_guard_detector_recipe.threat_cloned](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_detector_recipe) | resource |
| [oci_cloud_guard_responder_recipe.responder_cloned](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_responder_recipe) | resource |
| [oci_cloud_guard_target.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_target) | resource |
| [oci_cloud_guard_cloud_guard_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_cloud_guard_configuration) | data source |
| [oci_cloud_guard_detector_recipes.activity](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_detector_recipes) | data source |
| [oci_cloud_guard_detector_recipes.configuration](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_detector_recipes) | data source |
| [oci_cloud_guard_detector_recipes.threat](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_detector_recipes) | data source |
| [oci_cloud_guard_responder_recipes.responder](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/cloud_guard_responder_recipes) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_guard_configuration"></a> [cloud\_guard\_configuration](#input\_cloud\_guard\_configuration) | Cloud Guard settings, for managing Cloud Guard resources in OCI. Please see the comments within each attribute for details. | <pre>object({<br>    tenancy_ocid = string # the tenancy OCID.<br>    default_defined_tags = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource. <br>    default_freeform_tags = optional(map(string)) # the default freeform tags that are applied to all resources managed by this module. Overriden by freeform_tags attribute in each resource. <br>    reporting_region = optional(string) # the reporting region. Required when enable=true.<br>    self_manage_resources = optional(bool) # whether Oracle managed resources are created by customers. Default: false.<br>    cloned_recipes_prefix = optional(string) # a prefix to add to cloned recipes. Default: "oracle-cloned-".<br>    <br>    targets = optional(map(object({ # the Cloud Guard targets.<br>      compartment_id = optional(string) # the compartment where the Cloud Guard is created. It can be either the compartment OCID or a reference (a key) to the compartment OCID. It defaults to resource_id if resource_type is "COMPARTMENT".<br>      name = string # the Cloud Guard target name.<br>      resource_type = optional(string) # the resource type that Cloud Guard monitors. Valid values: "COMPARTMENT", "FACLOUD". Default: "COMPARTMENT".<br>      resource_id = string # the resource that Cloud Guard monitors. It can be either the resource OCID or a reference (a key) to a resource OCID. If the resource refers to a compartment, then Cloud Guard monitors the compartment and all its subcompartments.<br>      use_cloned_recipes = optional(bool) # whether the target should use clones of Oracle provided recipes. Default: false.<br>      defined_tags = optional(map(string)) # the target defined tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # the target freeform tags. default_freeform_tags is used if undefined.<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | `map(any)` | `null` | no |
| <a name="input_detector_recipes_order"></a> [detector\_recipes\_order](#input\_detector\_recipes\_order) | The order in which detector recipes are created. Use this to avoid any Cloud Guard recipe replacements due to the reordering of detector recipes. By default, the module creates threat, then configuration, then activity recipes. The order can be observed in the terraform plan output. | `list(string)` | <pre>[<br>  "threat",<br>  "configuration",<br>  "activity"<br>]</pre> | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable module output. | `bool` | `true` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"cloud-guard"` | no |
| <a name="input_responder_recipes_order"></a> [responder\_recipes\_order](#input\_responder\_recipes\_order) | The order in which responder recipes are created. Use this to avoid any Cloud Guard recipe replacements due to the reordering of responder recipes. The order can be observed in the terraform plan output. | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloned_activity_detector_recipe"></a> [cloned\_activity\_detector\_recipe](#output\_cloned\_activity\_detector\_recipe) | Cloned Cloud Guard activity detector recipe. |
| <a name="output_cloned_configuration_detector_recipe"></a> [cloned\_configuration\_detector\_recipe](#output\_cloned\_configuration\_detector\_recipe) | Cloned Cloud Guard configuration detector recipe. |
| <a name="output_cloned_responder_recipe"></a> [cloned\_responder\_recipe](#output\_cloned\_responder\_recipe) | Cloned Cloud Guard responder recipe. |
| <a name="output_cloned_threat_detector_recipe"></a> [cloned\_threat\_detector\_recipe](#output\_cloned\_threat\_detector\_recipe) | Cloned Cloud Guard threat detector recipe. |
| <a name="output_configuration"></a> [configuration](#output\_configuration) | Cloud Guard configuration information. |
| <a name="output_targets"></a> [targets](#output\_targets) | Cloud Guard target information. |
