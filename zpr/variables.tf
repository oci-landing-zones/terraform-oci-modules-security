variable "tenancy_ocid" {
  description = "OCID of the tenancy"
  type = string
  default = ""
}

variable "zpr_configuration" {
  type = object({
    default_defined_tags  = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource.
    default_freeform_tags = optional(map(string))

    namespaces = optional(map(object({
      compartment_id = string
      description    = string
      name           = string # Must be unique across all namespaces in your tenancy and cannot be changed once created. Names are case insensitive.
      defined_tags   = optional(map(string))
      freeform_tags  = optional(map(string))
    })))

    security_attributes = optional(map(object({
      description      = string
      name             = string
      namespace_id     = optional(string)
      namespace_key    = optional(string)
      validator_type   = optional(string) # Must be "ENUM" if adding validator_values
      validator_values = optional(list(string)) # Only applicable when validator_type = "ENUM"
    })))

    zpr_policies = optional(map(object({
      description   = string
      name          = string # Must be unique across all ZPR policies in the tenancy
      statements    = list(string) # Up to 25 statements per policy
      defined_tags  = optional(map(string))
      freeform_tags = optional(map(string))
    })))
  })
}

variable compartments_dependency {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type = map(object({
    id = string # the compartment OCID
  }))
  default = null
}