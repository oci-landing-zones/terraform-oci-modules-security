# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "vaults_configuration" {
  description = "Vaults configuration settings, defining all aspects to manage vaults and keys in OCI. Please see the comments within each attribute for details."
  type = object({

    default_compartment_id = string,                # the default compartment where all resources are defined. It's overriden by the compartment_id attribute within vaults and keys attributes. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
    default_defined_tags   = optional(map(string)), # the default defined tags. It's overriden by the defined_tags attribute within each object.
    default_freeform_tags  = optional(map(string)), # the default freeform tags. It's overriden by the frreform_tags attribute within each object.

    vaults = optional(map(object({           # the vaults to manage in this configuration.
      compartment_id = optional(string)      # the compartment where the vault is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name           = string                # vault name.
      type           = optional(string)      # vault type. Default is "DEFAULT", a regular virtual vault, in shared HSM partition. For an isolated partition, use "VIRTUAL_PRIVATE".
      defined_tags   = optional(map(string)) # vault defined_tags. default_defined_tags is used if undefined.
      freeform_tags  = optional(map(string)) # vault freeform_tags. default_freeform_tags is used if undefined.
      replica_region = optional(string)      # only available if the vault is a VPV (virtual private vault) and you want to replicate it to another region
    })))

    keys = optional(map(object({
      compartment_id            = optional(string)       # the compartment where the key is created. The vault compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name                      = string                 # key name.
      vault_key                 = optional(string)       # the index name (key) in the vaults attribute where this key belongs to.
      vault_management_endpoint = optional(string)       # the vault management endpoint where this key belongs to. If provided, this value takes precedence over vault_key. Use this attribute to add this key to a Vault that is managed elsewhere. It can be assigned either a literal endpoint URL or a reference (a key) to an endpoint URL.
      algorithm                 = optional(string)       # key encryption algorithm. Valid values: "AES", "RSA", and "ECDSA". Defaults is "AES". 
      length                    = optional(number)       # key length in bytes. "AES" lengths: 16, 24, 32. "RSA" lengths: 256, 384, 512. ECDSA lengths: 32, 48, 66. Default is 32.
      curve_id                  = optional(string)       # curve id for "ECDSA" keys.
      protection_mode           = optional(string)       # indicates how the key is persisted and where crypto operations are performed. Valid values: "HSM" and "SOFTWARE". Default is "HSM". 
      service_grantees          = optional(list(string)) # the OCI service names allowed to use the key.
      group_grantees            = optional(list(string)) # the IAM group names allowed to use the key-delegate.
      defined_tags              = optional(map(string))  # key freeform_tags. The vault freeform_tags is used if undefined.
      freeform_tags             = optional(map(string))  # key freeform_tags. The vault freeform_tags is used if undefined.
      versions                  = optional(list(string)) # a list of strings representing key versions. Use this to rotate keys.
      last_rotation_message     = optional(string)
      last_rotation_status      = optional(string)
      rotation_interval_in_days = optional(number)
      time_of_last_rotation     = optional(string)
      time_of_next_rotation     = optional(string)
      time_of_schedule_start    = optional(string)
      is_auto_rotation_enabled  = optional(bool)
    })))

    existing_keys_grants = optional(map(object({ # Use this attribute to create IAM policies for existing keys if needed
      key_id           = string                  # the existing key. It can be either a key OCID or a reference (a key) to the key OCID.
      compartment_id   = string                  # the compartment of the existing key. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      service_grantees = optional(list(string))  # the OCI service names allowed to use the key.
      group_grantees   = optional(list(string))  # the IAM group names allowed to use the key-delegate.
    })))
  })
  default = null
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type = map(object({
    id = string # the compartment OCID
  }))
  default = null
}

variable "vaults_dependency" {
  description = "A map of objects containing the externally managed vaults this module may depend on. All map objects must have the same type and must contain at least a 'management_endpoint' attribute (representing the management endpoint URL) of string type."
  type = map(object({
    management_endpoint = string # the vault management endpoint URL.
  }))
  default = null
}

variable "enable_output" {
  description = "Whether Terraform should enable module output."
  type        = bool
  default     = true
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "vaults"
}