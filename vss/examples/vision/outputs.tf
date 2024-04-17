# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "host_recipes" {
  value = module.vision_scanning.scanning_host_recipes
}

output "host_targets" {
  value = module.vision_scanning.scanning_host_targets
}

output "host_scanning_plugin_state" {
  value = module.vision_scanning.host_scanning_plugin_state
}