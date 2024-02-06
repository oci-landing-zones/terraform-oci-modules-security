# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "bastions" {
  description = "The bastions service details"
  value       = var.enable_output ? oci_bastion_bastion.these : null
}
output "sessions" {
  description = "The bastion sessions connections string"
  value = var.enable_output ? [for sessions in oci_bastion_session.these:
              {for key in var.sessions_configuration["sessions"]:
                sessions.display_name => key.ssh_private_key != null ? replace(replace(sessions.ssh_metadata["command"], "\"", "'"), "<privateKey>", key.ssh_private_key) : replace(sessions.ssh_metadata["command"], "\"", "'")
              }
  ] : null
}