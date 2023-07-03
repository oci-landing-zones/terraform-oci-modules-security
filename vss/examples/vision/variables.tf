# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}

variable "scanning_configuration" {
  description = "Vulnerability scanning configuration settings, defining all aspects to manage scanning aspects in OCI. Please see the comments within each attribute for details."
  type = object({

    default_compartment_ocid = string, # the default compartment where all resources are defined. It's overriden by the compartment_ocid attribute within each object.
    default_defined_tags   = optional(map(string)), # the default defined tags. It's overriden by the defined_tags attribute within each object.
    default_freeform_tags  = optional(map(string)), # the default freeform tags. It's overriden by the frreform_tags attribute within each object.

    host_recipes = optional(map(object({ # the host recipes to manage in this configuration.
      compartment_ocid = optional(string) # the compartment where the recipe is created. default_compartment_ocid is used if undefined.
      name = string # recipe name.
      port_scan_level = optional(string)
      schedule_settings = optional(object({
        type = string
        day_of_week = optional(string)
      }))
      agent_settings = optional(object({
        scan_level     = optional(string)
        vendor = optional(string)
        cis_benchmark_scan_level = optional(string)
      }))
      file_scan_settings = optional(object({
        enable = optional(bool)
        scan_recurrence = optional(string)
        folders_to_scan = optional(list(string))
        operating_system = optional(string)
      }))
      defined_tags = optional(map(string)) # recipe defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # recipe freeform_tags. default_freeform_tags is used if undefined.
    })))

    host_targets = optional(map(object({
      compartment_ocid = optional(string)
      name = string
      target_compartment_ocid = string
      target_instance_ocids = optional(list(string))
      host_recipe_key = string
      description = optional(string)
      defined_tags = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.
    })))

    container_recipes = optional(map(object({ # the container recipes to manage in this configuration.
      compartment_ocid = optional(string) # the compartment where the recipe is created. default_compartment_ocid is used if undefined.
      name = string # recipe name.
      scan_level = optional(string)
      image_count = optional(number)
      defined_tags = optional(map(string)) # recipe defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # recipe freeform_tags. default_freeform_tags is used if undefined.
    })))

    container_targets = optional(map(object({
      compartment_ocid = optional(string)
      name = string
      container_recipe_key = string
      description = optional(string)
      target_registry = object({
        compartment_ocid = string
        type = optional(string)
        repositories = optional(list(string)) # List of repositories to scan images in. If left empty, the target defaults to scanning all repos in the compartment_ocid.
        url = optional(string) # URL of the registry. Required for non-OCIR registry types (for OCIR registry types, it can be inferred from the tenancy).
      })
      defined_tags = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.
    })))

  })
}