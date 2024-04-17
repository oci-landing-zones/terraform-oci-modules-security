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
  type = any
  default = null
}

variable "oci_compartments_dependency" {
  type = object({
    bucket = string
    object = string 
  })
  default = null
}