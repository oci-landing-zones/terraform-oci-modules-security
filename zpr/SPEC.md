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
| [oci_security_attribute_security_attribute.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/security_attribute_security_attribute) | resource |
| [oci_security_attribute_security_attribute_namespace.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/security_attribute_security_attribute_namespace) | resource |
| [oci_zpr_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/zpr_configuration) | resource |
| [oci_zpr_zpr_policy.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/zpr_zpr_policy) | resource |
| [oci_identity_regions.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_security_attribute_security_attribute_namespaces.default_security_attribute_namespaces](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/security_attribute_security_attribute_namespaces) | data source |
| [oci_zpr_configuration.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/zpr_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | <pre>map(object({<br>    id = string # the compartment OCID<br>  }))</pre> | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of the tenancy | `string` | `""` | no |
| <a name="input_zpr_configuration"></a> [zpr\_configuration](#input\_zpr\_configuration) | n/a | <pre>object({<br>    default_defined_tags  = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource.<br>    default_freeform_tags = optional(map(string))<br><br>    namespaces = optional(map(object({<br>      compartment_id = string<br>      description    = string<br>      name           = string # Must be unique across all namespaces in your tenancy and cannot be changed once created. Names are case insensitive.<br>      defined_tags   = optional(map(string))<br>      freeform_tags  = optional(map(string))<br>    })))<br><br>    security_attributes = optional(map(object({<br>      description      = string<br>      name             = string<br>      namespace_id     = optional(string)<br>      validator_type   = optional(string) # Must be "ENUM" if adding validator_values<br>      validator_values = optional(list(string)) # Only applicable when validator_type = "ENUM"<br>    })))<br><br>    zpr_policies = optional(map(object({<br>      description   = string<br>      name          = string # Must be unique across all ZPR policies in the tenancy<br>      statements    = list(string) # Up to 25 statements per policy<br>      defined_tags  = optional(map(string))<br>      freeform_tags = optional(map(string))<br>    })))<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
