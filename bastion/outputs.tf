# Copyright (c) 2024, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "bastions" {
  description = "The bastions service details"
  value       = var.enable_output ? oci_bastion_bastion.these : null
}

output "sessions" {
  description = "The bastion sessions connections string"
  value = var.enable_output ? [for session, value in oci_bastion_session.these :
    { for key in var.sessions_configuration["sessions"] :
      session => key.ssh_private_key != null ? value.target_resource_details[0].session_type != "PORT_FORWARDING" ? replace(replace(value.ssh_metadata["command"], "\"", "'"), "<privateKey>", key.ssh_private_key) : replace(replace(replace(value.ssh_metadata["command"], "\"", "'"), "<privateKey>", key.ssh_private_key), "<localPort>", key.target_port) : replace(value.ssh_metadata["command"], "\"", "'")
    }
  ] : null

  
}
