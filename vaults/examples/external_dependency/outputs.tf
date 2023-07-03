# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vaults" {
  value = module.vision_vaults.vaults
}

output "keys" {
  value = module.vision_vaults.keys
}

output "keys_versions" {
  value = module.vision_vaults.keys_versions
}

output "policies" {
  value = module.vision_vaults.policies
}
