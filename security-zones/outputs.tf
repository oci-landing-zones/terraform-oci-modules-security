# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "configuration" {
  description = "Cloud Guard configuration information."
  value       = var.enable_output ? oci_cloud_guard_cloud_guard_configuration.this : null
}

output "recipes" {
  description = "The security zones recipes."
  value       = var.enable_output ? oci_cloud_guard_security_recipe.these : null
}

output "security_zones" {
  description = "The security zones."
  value       = var.enable_output ? oci_cloud_guard_security_zone.these : null
}

output "cloud_guard_config_status_before_apply" {
  value = var.enable_output ? data.oci_cloud_guard_cloud_guard_configuration.this : null
}