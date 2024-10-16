variable "tenancy_ocid" {
  default = ""
}

variable "zpr_configuration" {
  type = object({
    default_defined_tags = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource.
    default_freeform_tags = optional(map(string))

    namespace = optional(map(object({
      compartment_id = string
      description = string
      name = string
      defined_tags = optional(map(string))
      freeform_tags = optional(map(string))
    })))

    security_attributes = optional(map(object({
      description = string
      name = string
      security_attribute_namespace_id = string
      validator_type = string
      values = list(string)
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