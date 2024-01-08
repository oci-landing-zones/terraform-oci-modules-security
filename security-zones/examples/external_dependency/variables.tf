# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}

variable "security_zones_configuration" {
  description = "Security Zones configuration."
  type = object({
    tenancy_ocid = string # The tenancy OCID
    default_cis_level = optional(string) # The default CIS level for all recipes with an unspecified cis_level. Valid values: "1" and "2". Default: "1"
    default_security_policies_ocids = optional(list(string)) # The list of default Security Zone policies OCIDs for all recipes with an unspecified security_policies_ocids. These are merged with CIS Security Zone policies driven off cis_level.
    default_defined_tags = optional(map(string))
    default_freeform_tags = optional(map(string))
    reporting_region = optional(string) # the reporting region.
    self_manage_resources = optional(bool) # whether Oracle managed resources are created by customers. Default: false.
    
    recipes = optional(map(object({
      name = string
      compartment_id = string # the compartment where the Security Zone Recipe is created. It can be either the compartment OCID or a reference (a key) to the compartment OCID.
      description = optional(string)
      cis_level = optional(string) # Valid values: "1" and "2". Default: "1"
      security_policies_ocids = optional(list(string)) # List of default Security Zone policies OCIDs that are merged with CIS Security Zone policies. These are merged with CIS Security Zone policies driven off cis_level.
      defined_tags = optional(map(string))
      freeform_tags = optional(map(string))
    })))

    security_zones = map(object({
      name = string # The Security Zone name.
      compartment_id = string # The Security Zone compartment. It can be either the compartment OCID or a reference (a key) to the compartment OCID. Any existing Cloud Guard target for this compartment is replaced with the security zone. The security zone includes the default Oracle-managed configuration and activity detector recipes in Cloud Guard, and also scans resources in the zone for policy violations.
      recipe_key = string # The recipe key in recipes attribute.
      description = optional(string) # The security zone description.
      defined_tags = optional(map(string))
      freeform_tags = optional(map(string))
    })) 
  })
  default = null
}

variable "oci_compartments_dependency" {
  type = object({
    bucket = string
    object = string 
  })
  default = null
}