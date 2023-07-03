# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}

variable "cloud_guard_configuration" {
  description = "Cloud Guard settings, for managing Cloud Guard resources in OCI. Please see the comments within each attribute for details."
  type = object({
    tenancy_ocid = string # the tenancy OCID.
    default_defined_tags = optional(map(string)) # the default defined tags that are applied to all resources managed by this module. Overriden by defined_tags attribute in each resource. 
    default_freeform_tags = optional(map(string)) # the default freeform tags that are applied to all resources managed by this module. Overriden by freeform_tags attribute in each resource. 
    reporting_region = optional(string) # the reporting region. Required when enable=true.
    self_manage_resources = optional(bool) # whether Oracle managed resources are created by customers. Default: false.
    cloned_recipes_prefix = optional(string) # a prefix to add to cloned recipes. Default: "oracle-cloned-".
    
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
}

variable "oci_compartments_dependency" {
  type = object({
    bucket = string
    object = string 
  })
  default = null
}