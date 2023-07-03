# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "cloud_guard_config_status_after_apply" {
  value = module.vision_security_zones.configuration
}

output "security_zones" {
  value = module.vision_security_zones.security_zones
}

output "security_zones_recipes" {
  value = module.vision_security_zones.recipes
}