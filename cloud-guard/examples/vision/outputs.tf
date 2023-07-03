# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "configuration" {
  value = module.vision_cloud_guard.configuration
}

/*output "targets" {
  value = module.vision_cloud_guard.targets
}

output "cloned_configuration_detector_recipe" {
  value = module.vision_cloud_guard.cloned_configuration_detector_recipe
}

output "cloned_activity_detector_recipe" {
  value = module.vision_cloud_guard.cloned_activity_detector_recipe
}

output "cloned_threat_detector_recipe" {
  value = module.vision_cloud_guard.cloned_threat_detector_recipe
}

output "cloned_responder_recipe" {
  value = module.vision_cloud_guard.cloned_responder_recipe
} */