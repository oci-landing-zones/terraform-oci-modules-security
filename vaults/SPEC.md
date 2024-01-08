## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) |  < 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
| <a name="provider_oci.home"></a> [oci.home](#provider\_oci.home) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_policy.existing_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_policy.managed_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_kms_key.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key) | resource |
| [oci_kms_key_version.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key_version) | resource |
| [oci_kms_vault.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_vault) | resource |
| [oci_identity_compartment.existing_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |
| [oci_identity_compartment.managed_keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | `map(any)` | `null` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable module output. | `bool` | `true` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"vaults"` | no |
| <a name="input_vaults_configuration"></a> [vaults\_configuration](#input\_vaults\_configuration) | Vaults configuration settings, defining all aspects to manage vaults and keys in OCI. Please see the comments within each attribute for details. | <pre>object({<br><br>    default_compartment_id = string, # the default compartment where all resources are defined. It's overriden by the compartment_id attribute within vaults and keys attributes. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>    default_defined_tags   = optional(map(string)), # the default defined tags. It's overriden by the defined_tags attribute within each object.<br>    default_freeform_tags  = optional(map(string)), # the default freeform tags. It's overriden by the frreform_tags attribute within each object.<br><br>    vaults = optional(map(object({ # the vaults to manage in this configuration.<br>      compartment_id = optional(string) # the compartment where the vault is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string # vault name.<br>      type = optional(string) # vault type. Default is "DEFAULT", a regular virtual vault, in shared HSM partition. For an isolated partition, use "VIRTUAL_PRIVATE".<br>      defined_tags = optional(map(string)) # vault defined_tags. default_defined_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # vault freeform_tags. default_freeform_tags is used if undefined.<br>    })))<br><br>    keys = optional(map(object({<br>      compartment_id = optional(string) # the compartment where the key is created. The vault compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      name = string # key name.<br>      vault_key = optional(string) # the index name (key) in the vaults attribute where this key belongs to.<br>      vault_management_endpoint = optional(string) # the vault management endpoint where this key belongs to. If provided, this value takes precedence over vault_key. Use this attribute to add this key to a Vault that is managed elsewhere. It can be assigned either a literal endpoint URL or a reference (a key) to an endpoint URL.<br>      algorithm = optional(string) # key encryption algorithm. Valid values: "AES", "RSA", and "ECDSA". Defaults is "AES". <br>      length = optional(number) # key length in bytes. "AES" lengths: 16, 24, 32. "RSA" lengths: 256, 384, 512. ECDSA lengths: 32, 48, 66. Default is 32.<br>      curve_id = optional(string) # curve id for "ECDSA" keys.<br>      protection_mode = optional(string) # indicates how the key is persisted and where crypto operations are performed. Valid values: "HSM" and "SOFTWARE". Default is "HSM". <br>      service_grantees = optional(list(string)) # the OCI service names allowed to use the key.<br>      group_grantees = optional(list(string)) # the IAM group names allowed to use the key-delegate.<br>      defined_tags = optional(map(string)) # key freeform_tags. The vault freeform_tags is used if undefined.<br>      freeform_tags = optional(map(string)) # key freeform_tags. The vault freeform_tags is used if undefined.<br>      versions = optional(list(string)) # a list of strings representing key versions. Use this to rotate keys.<br>    })))<br><br>    existing_keys_grants = optional(map(object({ # Use this attribute to create IAM policies for existing keys if needed<br>      key_id = string # the existing key. It can be either a key OCID or a reference (a key) to the key OCID.<br>      compartment_id = string # the compartment of the existing key. It can be either a compartment OCID or a reference (a key) to the compartment OCID.<br>      service_grantees = optional(list(string)) # the OCI service names allowed to use the key.<br>      group_grantees = optional(list(string)) # the IAM group names allowed to use the key-delegate.<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_vaults_dependency"></a> [vaults\_dependency](#input\_vaults\_dependency) | A map of objects containing the externally managed vaults this module may depend on. All map objects must have the same type and must contain at least a 'management\_endpoint' attribute (representing the management endpoint URL) of string type. | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_keys"></a> [keys](#output\_keys) | The keys. |
| <a name="output_keys_versions"></a> [keys\_versions](#output\_keys\_versions) | The keys versions. |
| <a name="output_policies"></a> [policies](#output\_policies) | The policies. |
| <a name="output_vaults"></a> [vaults](#output\_vaults) | The vaults. |
