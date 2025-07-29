# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vaults" {
  description = "The vaults."
  value       = var.enable_output ? oci_kms_vault.these : null
}

output "keys" {
  description = "The keys."
  value       = var.enable_output ? oci_kms_key.these : null
}

output "keys_versions" {
  description = "The keys versions."
  value       = var.enable_output ? oci_kms_key_version.these : null
}

output "policies" {
  description = "The policies."
  value       = var.enable_output ? merge(oci_identity_policy.managed_keys, oci_identity_policy.existing_keys) : null
}
