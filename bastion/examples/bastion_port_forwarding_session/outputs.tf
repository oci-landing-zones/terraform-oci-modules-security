
# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "bastions" {
  description = "Bastion service details"
  value       = module.bastion.bastions
}

output "sessions" {
  description = "Sessions details"
  value       = module.bastion.sessions
}