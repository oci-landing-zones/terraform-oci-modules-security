# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "cloud_guard_configuration" {
  description = "Cloud Guard settings, for managing Cloud Guard resources in OCI. Please see the comments within each attribute for details."
  type = object({
    default_defined_tags = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource. 
    default_freeform_tags = optional(map(string)) # the default freeform tags that are applied to all resources managed by this module. Overriden by freeform_tags attribute in each resource. 
    reporting_region = optional(string) # the reporting region. It defaults to tenancy home region if undefined.
    self_manage_resources = optional(bool) # whether Oracle managed resources are created by customers. Default: false.
    cloned_recipes_prefix = optional(string) # a prefix to add to cloned recipes. Default: "oracle-cloned-".
    ignore_existing_targets = optional(bool, false) # whether to check if targets being requested already exist, a scenario that would make OCI to report an error during terraform apply, as only one target is allowed per target "COMPARTMENT" type. Default is false. When set to true, the module ignores the particular requested target if there is already a target defined for the specific compartment.
    
    targets = optional(map(object({ # the Cloud Guard targets.
      compartment_id = optional(string) # the compartment where the Cloud Guard is created. It can be either the compartment OCID or a reference (a key) to the compartment OCID. It defaults to resource_id if resource_type is "COMPARTMENT".
      name = string # the Cloud Guard target name.
      resource_type = optional(string) # the resource type that Cloud Guard monitors. Valid values: "COMPARTMENT", "FACLOUD". Default: "COMPARTMENT".
      resource_id = string # the resource that Cloud Guard monitors. It can be either the resource OCID or a reference (a key) to a resource OCID. If the resource refers to a compartment, then Cloud Guard monitors the compartment and all its subcompartments.
      use_cloned_recipes = optional(bool) # whether the target should use clones of Oracle provided recipes. Default: false.
      defined_tags = optional(map(string)) # the target defined tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # the target freeform tags. default_freeform_tags is used if undefined.
    })))
  })  
  default = null
}

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type = string
}

variable enable_output {
  description = "Whether Terraform should enable module output."
  type = bool
  default = true
}

variable module_name {
  description = "The module name."
  type = string
  default = "cloud-guard"
}

variable compartments_dependency {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type." 
  type = map(object({
    id = string
  }))
  default = null
}

variable "detector_recipes_order" {
  description = "The order in which detector recipes are created. Use this to avoid any Cloud Guard recipe replacements due to the reordering of detector recipes. By default, the module creates threat, then configuration, then activity recipes. The order can be observed in the terraform plan output."
  type = list(string)
  default = ["threat","configuration","activity"]
}

variable "responder_recipes_order" {
  description = "The order in which responder recipes are created. Use this to avoid any Cloud Guard recipe replacements due to the reordering of responder recipes. The order can be observed in the terraform plan output."
  type = list(string)
  default = ["default"]
}