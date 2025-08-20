# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "scanning_configuration" {
  description = "Vulnerability scanning configuration settings, defining all aspects to manage scanning aspects in OCI. Please see the comments within each attribute for details."
  type = object({

    default_compartment_id = string,                # the default compartment where all resources are defined. It's overriden by the compartment_id attribute within vaults and keys attributes. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
    default_defined_tags   = optional(map(string)), # the default defined tags. It's overriden by the defined_tags attribute within each object.
    default_freeform_tags  = optional(map(string)), # the default freeform tags. It's overriden by the frreform_tags attribute within each object.

    host_recipes = optional(map(object({ # the host recipes to manage in this configuration.
      compartment_id  = optional(string) # the compartment where the host recipe is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name            = string           # recipe name.
      port_scan_level = optional(string)
      schedule_settings = optional(object({
        type        = optional(string)
        day_of_week = optional(string)
      }))
      agent_settings = optional(object({
        scan_level               = optional(string)
        vendor                   = optional(string)
        cis_benchmark_scan_level = optional(string)
      }))
      file_scan_settings = optional(object({
        enable           = optional(bool)
        scan_recurrence  = optional(string)
        folders_to_scan  = optional(list(string))
        operating_system = optional(string)
      }))
      defined_tags  = optional(map(string)) # recipe defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # recipe freeform_tags. default_freeform_tags is used if undefined.
    })))

    host_targets = optional(map(object({
      compartment_id        = optional(string) # the compartment where the host target is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name                  = string
      target_compartment_id = string                 # the target compartment. All hosts (instances) in the compartment are scanning targets. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      target_instance_ids   = optional(list(string)) # the specific hosts (instances) to scan in the target compartment. Leave unset to scan all instances. It can be either instances OCIDs or references (keys) to instances OCIDs.
      host_recipe_id        = string                 # the recipe id to use for the target. This can be a literal OCID or a referring key within host_recipes.
      description           = optional(string)
      defined_tags          = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.
      freeform_tags         = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.
    })))

    container_recipes = optional(map(object({ # the container recipes to manage in this configuration.
      compartment_id = optional(string)       # the compartment where the container recipe is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name           = string                 # recipe name.
      scan_level     = optional(string)       # the scan level. Default: "STANDARD".
      image_count    = optional(number)       # the number of images to scan initially when the recipe is created. Default: 0
      defined_tags   = optional(map(string))  # recipe defined_tags. default_defined_tags is used if undefined.
      freeform_tags  = optional(map(string))  # recipe freeform_tags. default_freeform_tags is used if undefined.
    })))

    container_targets = optional(map(object({
      compartment_id      = optional(string) # the compartment where the container target is created. default_compartment_id is used if undefined. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
      name                = string
      container_recipe_id = string # the recipe id to use for the target. This can be a literal OCID or a referring key within container_recipes.
      description         = optional(string)
      target_registry = object({
        compartment_id = string                 # the registry target compartment. All containers in the compartment are scanning targets. It can be either a compartment OCID or a reference (a key) to the compartment OCID.
        type           = optional(string)       # the registry type. Default: "OCIR".
        repositories   = optional(list(string)) # list of repositories to scan images. If undefined, the target defaults to scanning all repos in the compartment_ocid.
        url            = optional(string)       # URL of the registry. Required for non-OCI registry types (for OCI registry types, it can be inferred from the tenancy).
      })
      defined_tags  = optional(map(string)) # target defined_tags. default_defined_tags is used if undefined.
      freeform_tags = optional(map(string)) # target freeform_tags. default_freeform_tags is used if undefined.
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

variable "enable_output" {
  description = "Whether Terraform should enable module output."
  type        = bool
  default     = true
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "vss"
}