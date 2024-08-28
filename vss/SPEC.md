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
| [oci_vulnerability_scanning_container_scan_recipe.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vulnerability_scanning_container_scan_recipe) | resource |
| [oci_vulnerability_scanning_container_scan_target.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vulnerability_scanning_container_scan_target) | resource |
| [oci_vulnerability_scanning_host_scan_recipe.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vulnerability_scanning_host_scan_recipe) | resource |
| [oci_vulnerability_scanning_host_scan_target.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vulnerability_scanning_host_scan_target) | resource |
| [oci_artifacts_container_repositories.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/artifacts_container_repositories) | data source |
| [oci_core_instances.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | <pre>map(object({<br>    id = string # the compartment OCID<br>  }))</pre> | `null` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable module output. | `bool` | `true` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"vss"` | no |
| <a name="input_scanning_configuration"></a> [scanning\_configuration](#input\_scanning\_configuration) | Vulnerability scanning configuration settings, defining all aspects to manage scanning aspects in OCI. Please see the comments within each attribute for details. | <pre>object({<br><br>    default_compartment_id = string, # the default compartment where all resources are defined. It's overriden by the compartment_id attribute within vaults and keys attributes. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>    default_defined_tags   = optional(map(string)), # the default defined tags. It's overriden by the defined_tags attribute within each object.<br>    default_freeform_tags  = optional(map(string)), # the default freeform tags. It's overriden by the frreform_tags attribute within each object.<br><br>    host_recipes = optional(map(object({ # the host recipes to manage in this configuration.<br>      compartment_id = optional(string) # the compartment where the host recipe is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string # recipe name.<br>      port_scan_level = optional(string)<br>      schedule_settings = optional(object({<br>        type = optional(string)<br>        day_of_week = optional(string)<br>      }))<br>      agent_settings = optional(object({<br>        scan_level     = optional(string)<br>        vendor = optional(string)<br>        cis_benchmark_scan_level = optional(string)<br>      }))<br>      file_scan_settings = optional(object({<br>        enable = optional(bool)<br>        scan_recurrence = optional(string)<br>        folders_to_scan = optional(list(string))<br>        operating_system = optional(string)<br>      }))<br>      defined_tags = optional(map(string)) # recipe defined_tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # recipe freeform_tags. default_freeform_tags is used if undefined.<br>    })))<br><br>    host_targets = optional(map(object({<br>      compartment_id = optional(string) # the compartment where the host target is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string<br>      target_compartment_id = string # the target compartment. All hosts (instances) in the compartment are scanning targets. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      target_instance_ids = optional(list(string)) # the specific hosts (instances) to scan in the target compartment. Leave unset to scan all instances. It can be either instances OCIDs or references (keys) to instances OCIDs.<br>      host_recipe_id = string # the recipe id to use for the target. This can be a literal OCID or a referring key within host_recipes.<br>      description = optional(string)<br>      defined_tags = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.<br>    })))<br><br>    container_recipes = optional(map(object({ # the container recipes to manage in this configuration.<br>      compartment_id = optional(string) # the compartment where the container recipe is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string # recipe name.<br>      scan_level = optional(string) # the scan level. Default: "STANDARD".<br>      image_count = optional(number) # the number of images to scan initially when the recipe is created. Default: 0<br>      defined_tags = optional(map(string)) # recipe defined_tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # recipe freeform_tags. default_freeform_tags is used if undefined.<br>    })))<br><br>    container_targets = optional(map(object({<br>      compartment_id = optional(string) # the compartment where the container target is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string<br>      container_recipe_id = string # the recipe id to use for the target. This can be a literal OCID or a referring key within container_recipes.<br>      description = optional(string)<br>      target_registry = object({<br>        compartment_id = string # the registry target compartment. All containers in the compartment are scanning targets. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>        type = optional(string) # the registry type. Default: "OCIR".<br>        repositories = optional(list(string)) # list of repositories to scan images. If undefined, the target defaults to scanning all repos in the compartment_ocid.<br>        url = optional(string) # URL of the registry. Required for non-OCI registry types (for OCI registry types, it can be inferred from the tenancy).<br>      })<br>      defined_tags = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.<br>    })))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_host_scanning_plugin_state"></a> [host\_scanning\_plugin\_state](#output\_host\_scanning\_plugin\_state) | The Cloud Agent VSS plugin state for target instances. |
| <a name="output_scanning_container_recipes"></a> [scanning\_container\_recipes](#output\_scanning\_container\_recipes) | The VSS container recipes. |
| <a name="output_scanning_container_targets"></a> [scanning\_container\_targets](#output\_scanning\_container\_targets) | The VSS container targets. |
| <a name="output_scanning_host_recipes"></a> [scanning\_host\_recipes](#output\_scanning\_host\_recipes) | The VSS host (instance) recipes. |
| <a name="output_scanning_host_targets"></a> [scanning\_host\_targets](#output\_scanning\_host\_targets) | The VSS host (instance) targets. |
