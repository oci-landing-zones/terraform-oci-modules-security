# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output configuration {
  description = "Cloud Guard configuration information."
  value = var.enable_output ? (length(oci_cloud_guard_cloud_guard_configuration.this) > 0 ? oci_cloud_guard_cloud_guard_configuration.this[0] : null) : null
}

output targets {
  description = "Cloud Guard target information."
  value = var.enable_output ? (length(oci_cloud_guard_target.these) > 0 ? oci_cloud_guard_target.these : null) : null
}

output "cloned_configuration_detector_recipe" {
  description = "Cloned Cloud Guard configuration detector recipe."  
  value = var.enable_output ? (length(oci_cloud_guard_detector_recipe.configuration_cloned) > 0 ? oci_cloud_guard_detector_recipe.configuration_cloned[0] : null) : null
}

output "cloned_activity_detector_recipe" {
  description = "Cloned Cloud Guard activity detector recipe."
  value = var.enable_output ? (length(oci_cloud_guard_detector_recipe.activity_cloned) > 0 ? oci_cloud_guard_detector_recipe.activity_cloned[0] : null) : null
}

output "cloned_threat_detector_recipe" {
  description = "Cloned Cloud Guard threat detector recipe."  
  value = var.enable_output ? (length(oci_cloud_guard_detector_recipe.threat_cloned) > 0 ? oci_cloud_guard_detector_recipe.threat_cloned[0] : null) : null
}

output "cloned_responder_recipe" {
  description = "Cloned Cloud Guard responder recipe."
  value = var.enable_output ? (length(oci_cloud_guard_responder_recipe.responder_cloned) > 0 ? oci_cloud_guard_responder_recipe.responder_cloned[0] : null) : null
}

output "existing_targets" {
  value = var.enable_output ? local.existing_targets : null
}

output "actual_targets" {
  value = var.enable_output ? local.actual_targets : null
}

output "ignored_targets" {
  value = var.enable_output ? local.ignored_targets : null
}