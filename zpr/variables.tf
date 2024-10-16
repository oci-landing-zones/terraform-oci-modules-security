variable "tenancy_ocid" {
  default = ""
}

variable "zpr_configuration" {
  type = object({
    default_defined_tags = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource.
    default_freeform_tags = optional(map(string))

    namespaces = optional(map(object({
      compartment_id = string
      description = string
      name = string # Must be unique across all namespaces in your tenancy and cannot be changed once created. Names are case insensitive.
      defined_tags = optional(map(string))
      freeform_tags = optional(map(string))
    })))

    security_attributes = optional(map(object({
      description = string
      name = string
      namespace_id = optional(string)
      namespace_key = optional(string)
      validators = optional(list(object({
        validator_type = optional(string) # Allowed values: "DEFAULT" or "ENUM"
        values = optional(list(string)) # Only applicable when validator_type = "ENUM"
      })))
    })))

    zpr_policies = optional(map(object({
      compartment_id = string
      description = string
      name = string
      statements = string
      defined_tags = optional(map(string))
      freeform_tags = optional(map(string))
    })))
  })
}