# Copyright (c) 2024, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "bastions" {
  description = "The bastions service details."
  value       = var.enable_output ? oci_bastion_bastion.these : null
}

output "sessions" {
  description = "The bastion sessions connection string."
  value       = var.enable_output ? { for k, v in oci_bastion_session.these : k => v.ssh_metadata["command"] } : null
}
