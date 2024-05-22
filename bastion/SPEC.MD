## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | < 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_bastion_bastion.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_bastion) | resource |
| [oci_bastion_session.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_session) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastions_configuration"></a> [bastions\_configuration](#input\_bastions\_configuration) | Bastion configuration attributes. | <pre>object({<br>    default_compartment_id        = optional(string)       # the default compartment where all resources are defined. It's overriden by the compartment_ocid attribute within each object.<br>    default_defined_tags          = optional(map(string))  # the default defined tags. It's overriden by the defined_tags attribute within each object.<br>    default_freeform_tags         = optional(map(string))  # the default freeform tags. It's overriden by the freeform_tags attribute within each object.<br>    default_subnet_id             = optional(string)       # the default subnet_id. It`s overriden by the subnet_id attribute in each object.<br>    default_cidr_block_allow_list = optional(list(string)) # the default cidr block allow list. It`s overriden by the cidr_block_allow_list attribute in each object.<br>    enable_cidr_check             = optional(bool)         # whether provided CIDR blocks should be checked for "0.0.0.0\0".<br>    bastions = map(object({ <br>      bastion_type               = optional(string)            # type of bastion. Allowed value is "STANDARD".<br>      compartment_id             = optional(string)            # the compartment where the bastion is created. default_compartment_ocid is used if this is not defined.<br>      subnet_id                  = optional(string)            # the subnet id where the bastion will be created. default_subnet_id is used if this is not defined.<br>      defined_tags               = optional(map(string))       # bastions defined_tags. default_defined_tags is used if this is not defined.<br>      freeform_tags              = optional(map(string))       # bastions freeform_tags. default_freeform_tags is used if this is not defined.<br>      cidr_block_allow_list      = optional(list(string))      # list of cidr blocks that will be able to connect to bastion. default_cidr_block_allow_list is used if this is not defined.<br>      enable_dns_proxy           = optional(bool)              # bool to enable dns_proxy on the bastion.<br>      max_session_ttl_in_seconds = optional(number)            # maximum allowd time to live for a session on the bastion.<br>      name                       = string                      # bastion name<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | <pre>map(object({<br>    id = string # the compartment OCID<br>  }))</pre> | `null` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable the module output. | `bool` | `true` | no |
| <a name="input_endpoints_dependency"></a> [endpoints\_dependency](#input\_endpoints\_dependency) | A map of objects containing the externally managed endpoints this module may depend on. The objects, when defined, must contain at least an 'ip\_address' attribute (representing the endpoint private IP address of the target resource) of string type. | <pre>map(object({<br>    ip_address = string # the private IP address<br>  }))</pre> | `null` | no |
| <a name="input_instances_dependency"></a> [instances\_dependency](#input\_instances\_dependency) | A map of objects containing the externally managed Compute instances this module may depend on. The objects, when defined, must contain at least an 'id' attribute (representing the instance OCID) of string type. | <pre>map(object({<br>    id = string # the instance OCID<br>  }))</pre> | `null` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"bastion"` | no |
| <a name="input_network_dependency"></a> [network\_dependency](#input\_network\_dependency) | A map of objects containing the externally managed network resources this module may depend on. Supported resources are 'subnets', represent as a map of objects. Each object must have an 'id' attribute of string type set with the subnet OCID. | <pre>object({<br>    subnets = optional(map(object({<br>      id = string # the subnet OCID<br>    })))<br>  })</pre> | `null` | no |
| <a name="input_sessions_configuration"></a> [sessions\_configuration](#input\_sessions\_configuration) | Sessions configuration attributes. | <pre>object({<br>    default_ssh_public_key   = optional(string)        # the default ssh_public_key path. It's overriden by the ssh_public_key attribute within each object.<br>    default_session_type     = optional(string)        # the default session_type. It's overriden by the session_type attribute within each object.<br>    sessions = map(object({ <br>      bastion_id             = string                  # the ocid or the key of Bastion where the session will be created.<br>      ssh_public_key         = optional(string)        # the ssh_public_key path used by the session to connect to target. The default_ssh_public_key is used if this is not defined.<br>      session_type           = optional(string)        # session type of the session. Supported values are MANAGED_SSH and PORT_FORWARDING. The default_session_type is used if this is not defined.<br>      target_resource        = string                  # Either the FQDN, OCID or IP of the target resource to connect the session to.<br>      target_user            = optional(string)        # User of the target that will be used by session. It is required only with MANAGED_SSH. <br>      target_port            = number                  # Port number that will be used by the session.<br>      session_ttl_in_seconds = optional(number)        # Session time to live<br>      session_name           = string                  # Session name<br>    }))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastions"></a> [bastions](#output\_bastions) | The bastions service details. |
| <a name="output_sessions"></a> [sessions](#output\_sessions) | The bastion sessions connection string. |
