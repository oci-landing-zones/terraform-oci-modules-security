# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "scanning_host_recipes" {
  description = "The VSS host (instance) recipes."
  value       = var.enable_output ? oci_vulnerability_scanning_host_scan_recipe.these : null
}

output "scanning_container_recipes" {
  description = "The VSS container recipes."
  value       = var.enable_output ? oci_vulnerability_scanning_container_scan_recipe.these : null
}

output "scanning_host_targets" {
  description = "The VSS host (instance) targets."
  value       = var.enable_output ? oci_vulnerability_scanning_host_scan_target.these : null
}

output "scanning_container_targets" {
  description = "The VSS container targets."
  value       = var.enable_output ? oci_vulnerability_scanning_container_scan_target.these : null
}

output "host_scanning_plugin_state" {
  description = "The Cloud Agent VSS plugin state for target instances."
  value       = var.enable_output ? local.vss_plugin_state : null
}