# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  is_cloud_guard_enabled = data.oci_cloud_guard_cloud_guard_configuration.this.status == "ENABLED" ? true : length(oci_cloud_guard_cloud_guard_configuration.this) > 0 ? (oci_cloud_guard_cloud_guard_configuration.this[0].status == "ENABLED" ? true : false) : false
  cloned_recipes_prefix = var.cloud_guard_configuration != null ? (var.cloud_guard_configuration.cloned_recipes_prefix != null ? var.cloud_guard_configuration.cloned_recipes_prefix : "oracle-cloned") : ""
  
  is_create_cloned_recipes = length(flatten([
    for target_value in (var.cloud_guard_configuration != null ? (var.cloud_guard_configuration.targets != null ? var.cloud_guard_configuration.targets : {}) : {}) : [target_value.use_cloned_recipes]
  if coalesce(target_value.use_cloned_recipes,false) == true ])) > 0
}

resource "oci_cloud_guard_cloud_guard_configuration" "this" {
  lifecycle {
    precondition {
      condition = data.oci_cloud_guard_cloud_guard_configuration.this.status == "ENABLED" ? true : var.cloud_guard_configuration.reporting_region != null ? true : false
      error_message = "VALIDATION FAILURE: reporting_region must be provided when enabling Cloud Guard."
    }
  }  
  count = data.oci_cloud_guard_cloud_guard_configuration.this.status == "DISABLED" ? 1 : 0 # we only manage this resource if Cloud Guard is currently disabled, which means we have to enable it.
    compartment_id        = var.cloud_guard_configuration.tenancy_ocid
    reporting_region      = var.cloud_guard_configuration.reporting_region
    status                = "ENABLED"
    self_manage_resources = var.cloud_guard_configuration.self_manage_resources != null ? (var.cloud_guard_configuration.self_manage_resources == true ? true : false) : false
}

resource "oci_cloud_guard_target" "these" {
  for_each = var.cloud_guard_configuration != null ? (var.cloud_guard_configuration.targets != null ? var.cloud_guard_configuration.targets : {}) : {}
    #-- If resource_type is null or resource_type == "COMPARTMENT", the compartment_ocid defaults to target_resource_ocid.
    compartment_id       = each.value.resource_type != null ? (each.value.resource_type == "COMPARTMENT" ? (length(regexall("^ocid1.*$", each.value.resource_id)) > 0 ? each.value.resource_id : var.compartments_dependency[each.value.resource_id].id) : (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id)) : (length(regexall("^ocid1.*$", each.value.resource_id)) > 0 ? each.value.resource_id : var.compartments_dependency[each.value.resource_id].id)
    display_name         = each.value.name
    target_resource_id   = length(regexall("^ocid1.*$", each.value.resource_id)) > 0 ? each.value.resource_id : var.compartments_dependency[each.value.resource_id].id
    target_resource_type = each.value.resource_type != null ? each.value.resource_type : "COMPARTMENT"
    defined_tags         = each.value.defined_tags != null ? each.value.defined_tags : var.cloud_guard_configuration.default_defined_tags
    freeform_tags        = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.cloud_guard_configuration.default_freeform_tags)
  
  dynamic "target_detector_recipes" {
    for_each = {
      "${index(var.detector_recipes_order,"threat")}_threat" : {"id" : each.value.use_cloned_recipes != null ? (each.value.use_cloned_recipes ? oci_cloud_guard_detector_recipe.threat_cloned[0].id : data.oci_cloud_guard_detector_recipes.threat.detector_recipe_collection[0].items[0].id) : data.oci_cloud_guard_detector_recipes.threat.detector_recipe_collection[0].items[0].id },
      "${index(var.detector_recipes_order,"configuration")}_configuration" : {"id" : each.value.use_cloned_recipes != null ? (each.value.use_cloned_recipes ? oci_cloud_guard_detector_recipe.configuration_cloned[0].id : data.oci_cloud_guard_detector_recipes.configuration.detector_recipe_collection[0].items[0].id) : data.oci_cloud_guard_detector_recipes.configuration.detector_recipe_collection[0].items[0].id },
      "${index(var.detector_recipes_order,"activity")}_activity" : {"id" : each.value.use_cloned_recipes != null ? (each.value.use_cloned_recipes ? oci_cloud_guard_detector_recipe.activity_cloned[0].id : data.oci_cloud_guard_detector_recipes.activity.detector_recipe_collection[0].items[0].id) : data.oci_cloud_guard_detector_recipes.activity.detector_recipe_collection[0].items[0].id } 
    }
    content {
      detector_recipe_id = target_detector_recipes.value["id"]
    }
  }

  dynamic "target_responder_recipes" {
    for_each = {
      "${index(var.responder_recipes_order,"default")}_default" : {"id" : each.value.use_cloned_recipes != null ? (each.value.use_cloned_recipes ? oci_cloud_guard_responder_recipe.responder_cloned[0].id : data.oci_cloud_guard_responder_recipes.responder.responder_recipe_collection[0].items[0].id) : data.oci_cloud_guard_responder_recipes.responder.responder_recipe_collection[0].items[0].id }
    }
    content {
      responder_recipe_id = target_responder_recipes.value["id"]
    }
  }
}

resource "oci_cloud_guard_detector_recipe" "configuration_cloned" {
  count = local.is_create_cloned_recipes == true ? 1 : 0
    compartment_id = var.cloud_guard_configuration.tenancy_ocid
    display_name   = "${local.cloned_recipes_prefix}-configuration-detector-recipe"
    description    = "CIS Landing Zone configuration detector recipe (cloned from Oracle managed recipe)."
    defined_tags   = var.cloud_guard_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, var.cloud_guard_configuration.default_freeform_tags)
    source_detector_recipe_id = data.oci_cloud_guard_detector_recipes.configuration.detector_recipe_collection[0].items[0].id
}

resource "oci_cloud_guard_detector_recipe" "activity_cloned" {
  count = local.is_create_cloned_recipes == true ? 1 : 0
    compartment_id = var.cloud_guard_configuration.tenancy_ocid
    display_name   = "${local.cloned_recipes_prefix}-activity-detector-recipe"
    description    = "CIS Landing Zone activity detector recipe (cloned from Oracle managed recipe)."
    defined_tags   = var.cloud_guard_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, var.cloud_guard_configuration.default_freeform_tags)
    source_detector_recipe_id = data.oci_cloud_guard_detector_recipes.activity.detector_recipe_collection[0].items[0].id
}

resource "oci_cloud_guard_detector_recipe" "threat_cloned" {
  count = local.is_create_cloned_recipes == true ? 1 : 0
    compartment_id = var.cloud_guard_configuration.tenancy_ocid
    display_name   = "${local.cloned_recipes_prefix}-threat-detector-recipe"
    description    = "CIS Landing Zone threat detector recipe (cloned from Oracle managed recipe)."
    defined_tags   = var.cloud_guard_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, var.cloud_guard_configuration.default_freeform_tags)
    source_detector_recipe_id = data.oci_cloud_guard_detector_recipes.threat.detector_recipe_collection[0].items[0].id
}

resource "oci_cloud_guard_responder_recipe" "responder_cloned" {
  count = local.is_create_cloned_recipes == true ? 1 : 0
    compartment_id = var.cloud_guard_configuration.tenancy_ocid
    display_name   = "${local.cloned_recipes_prefix}-responder-recipe"
    description    = "CIS Landing Zone responder recipe (cloned from Oracle managed recipe)."
    defined_tags   = var.cloud_guard_configuration.default_defined_tags
    freeform_tags  = merge(local.cislz_module_tag, var.cloud_guard_configuration.default_freeform_tags)
    source_responder_recipe_id = data.oci_cloud_guard_responder_recipes.responder.responder_recipe_collection[0].items[0].id
}