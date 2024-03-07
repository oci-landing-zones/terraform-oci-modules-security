# Copyright (c) 2024, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "bastions_configuration" {
  description = "Bastion configuration attributes."
  type = object({
    default_compartment_id        = optional(string)       # the default compartment where all resources are defined. It's overriden by the compartment_ocid attribute within each object.
    default_defined_tags          = optional(map(string))  # the default defined tags. It's overriden by the defined_tags attribute within each object.
    default_freeform_tags         = optional(map(string))  # the default freeform tags. It's overriden by the freeform_tags attribute within each object.
    default_subnet_id             = optional(string)       # the default subnet_id. It`s overriden by the subnet_id attribute in each object.
    default_cidr_block_allow_list = optional(list(string)) # the default cidr block allow list. It`s overriden by the cidr_block_allow_list attribute in each object.
    enable_cidr_check             = optional(bool,true)    # whether provided CIDR blocks should be checked for "0.0.0.0\0".
    bastions = map(object({ 
      bastion_type               = optional(string,"standard") # type of bastion. Allowed value is "STANDARD".
      compartment_id             = optional(string)            # the compartment where the bastion is created. default_compartment_ocid is used if this is not defined.
      subnet_id                  = optional(string)            # the subnet id where the bastion will be created. default_subnet_id is used if this is not defined.
      defined_tags               = optional(map(string))       # bastions defined_tags. default_defined_tags is used if this is not defined.
      freeform_tags              = optional(map(string))       # bastions freeform_tags. default_freeform_tags is used if this is not defined.
      cidr_block_allow_list      = optional(list(string))      # list of cidr blocks that will be able to connect to bastion. default_cidr_block_allow_list is used if this is not defined.
      enable_dns_proxy           = optional(bool,true)         # bool to enable dns_proxy on the bastion.
      max_session_ttl_in_seconds = optional(number)            # maximum allowd time to live for a session on the bastion.
      name                       = string                      # bastion name
    }))
  })
  default = null
}

variable "sessions_configuration" {
  description = "Sessions configuration attributes."
  type = object({
    default_ssh_public_key   = optional(string)        # the default ssh_public_key path. It's overriden by the ssh_public_key attribute within each object.
    default_session_type     = optional(string)        # the default session_type. It's overriden by the session_type attribute within each object.
    sessions = map(object({ 
      bastion_id             = string                  # the ocid or the key of Bastion where the session will be created.
      ssh_public_key         = optional(string)        # the ssh_public_key path used by the session to connect to target. The default_ssh_public_key is used if this is not defined.
      session_type           = optional(string)        # session type of the session. Supported values are MANAGED_SSH and PORT_FORWARDING. The default_session_type is used if this is not defined.
      target_resource        = string                  # Either the FQDN, OCID or IP of the target resource to connect the session to.
      target_user            = optional(string)        # User of the target that will be used by session. It is required only with MANAGED_SSH. 
      target_port            = number                  # Port number that will be used by the session.
      session_ttl_in_seconds = optional(number,10800)  # Session time to live
      session_name           = string                  # Session name
    }))
  })
  default = null
}

variable "enable_output" {
  description = "Whether Terraform should enable the module output."
  type        = bool
  default     = true
}
variable "module_name" {
  description = "The module name."
  type        = string
  default     = "bastion"
}
variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type." 
  type = map(any)
  default = null
}
variable "network_dependency" {
  description = "A map of objects containing the externally managed network resources this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the network resource OCID) of string type." 
  type = map(any)
  default = null
}
variable "instances_dependency" {
  description = "A map of objects containing the externally managed Compute instances this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the instance OCID) of string type." 
  type = map(any)
  default = null
}
variable "clusters_dependency" {
  description = "A map of objects containing the externally managed clusters this module may depend on." 
  type = map(any)
  default = null
}