# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#-- Host recipes
resource "oci_vulnerability_scanning_host_scan_recipe" "these" {
  lifecycle {
      create_before_destroy = true
  }  
  for_each = var.scanning_configuration != null ? (var.scanning_configuration.host_recipes != null ? var.scanning_configuration.host_recipes : {}) : {}
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.scanning_configuration.default_compartment_id)) > 0 ? var.scanning_configuration.default_compartment_id : var.compartments_dependency[var.scanning_configuration.default_compartment_id].id)
    display_name = each.value.name 
    port_settings {
      scan_level = upper(coalesce(each.value.port_scan_level,"STANDARD"))
    }
    schedule {
      type = each.value.schedule_settings != null ? upper(coalesce(each.value.schedule_settings.type,"WEEKLY")) : "WEEKLY"
      day_of_week = each.value.schedule_settings != null ? upper(coalesce(each.value.schedule_settings.day_of_week,"SUNDAY")) : "SUNDAY"
    } 
    agent_settings {
      scan_level = each.value.agent_settings != null ? upper(coalesce(each.value.agent_settings.scan_level,"STANDARD")) : "STANDARD"
      agent_configuration {
        vendor = each.value.agent_settings != null ? upper(coalesce(each.value.agent_settings.vendor,"OCI")) : "OCI"
        cis_benchmark_settings {
          scan_level = each.value.agent_settings != null ? upper(coalesce(each.value.agent_settings.cis_benchmark_scan_level,"STRICT")) : "STRICT"
        }
      }
    }
    application_settings {
      application_scan_recurrence = each.value.file_scan_settings != null ? (each.value.file_scan_settings.scan_recurrence != null ? upper(each.value.file_scan_settings.scan_recurrence) : (each.value.schedule_settings != null ? (each.value.schedule_settings.type != null ? (each.value.schedule_settings.type == "WEEKLY" ? "FREQ=WEEKLY;INTERVAL=2;WKST=${substr(upper(each.value.schedule_settings.day_of_week != null ? each.value.schedule_settings.day_of_week : "SUNDAY"),0,2)}" : "FREQ=WEEKLY;INTERVAL=2;WKST=SU") : "FREQ=WEEKLY;INTERVAL=2;WKST=SU") : "FREQ=WEEKLY;INTERVAL=2;WKST=SU")) : "FREQ=WEEKLY;INTERVAL=2;WKST=SU"
      folders_to_scan {
        folder = each.value.file_scan_settings != null ? (each.value.file_scan_settings.folders_to_scan != null ? join(";", each.value.file_scan_settings.folders_to_scan) : "/") : "/"
        operatingsystem = each.value.file_scan_settings != null ? upper(coalesce(each.value.file_scan_settings.operating_system,"LINUX")) : "LINUX"
      }
      is_enabled = each.value.file_scan_settings != null ? coalesce(each.value.file_scan_settings.enable,true) : true
    }
    defined_tags = each.value.defined_tags != null ? each.value.defined_tags : var.scanning_configuration.default_defined_tags
    freeform_tags = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.scanning_configuration.default_freeform_tags)
}

#-- Host targets
resource "oci_vulnerability_scanning_host_scan_target" "these" {
  for_each = var.scanning_configuration != null ? (var.scanning_configuration.host_targets != null ? var.scanning_configuration.host_targets : {}) : {}
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.scanning_configuration.default_compartment_id)) > 0 ? var.scanning_configuration.default_compartment_id : var.compartments_dependency[var.scanning_configuration.default_compartment_id].id)
    display_name          = each.value.name
    description           = each.value.description != null ? each.value.description : each.value.name
    host_scan_recipe_id   = length(regexall("^ocid1.*$", each.value.host_recipe_id)) > 0 ? each.value.host_recipe_id : oci_vulnerability_scanning_host_scan_recipe.these[each.value.host_recipe_id].id
    target_compartment_id = length(regexall("^ocid1.*$", each.value.target_compartment_id)) > 0 ? each.value.target_compartment_id : var.compartments_dependency[each.value.target_compartment_id].id
    instance_ids          = each.value.target_instance_ids != null ? [ for id in each.value.target_instance_ids : length(regexall("^ocid1.*$", id)) > 0 ? id : var.compartments_dependency[id].id ] : null
    defined_tags          = each.value.defined_tags != null ? each.value.defined_tags : var.scanning_configuration.default_defined_tags
    freeform_tags         = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.scanning_configuration.default_freeform_tags)
}

#-- Container recipes
resource "oci_vulnerability_scanning_container_scan_recipe" "these" {
  lifecycle {
      create_before_destroy = true
  }  
  for_each = var.scanning_configuration != null ? (var.scanning_configuration.container_recipes != null ? var.scanning_configuration.container_recipes : {}) : {}
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.scanning_configuration.default_compartment_id)) > 0 ? var.scanning_configuration.default_compartment_id : var.compartments_dependency[var.scanning_configuration.default_compartment_id].id)
    display_name = each.value.name
    scan_settings {
      scan_level = upper(coalesce(each.value.scan_level,"STANDARD"))
    }
    image_count = coalesce(each.value.image_count,1)
    defined_tags = each.value.defined_tags != null ? each.value.defined_tags : var.scanning_configuration.default_defined_tags
    freeform_tags = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.scanning_configuration.default_freeform_tags)
}

locals {
  target_container_scan_cmps = var.scanning_configuration != null ? ([for t in (var.scanning_configuration.container_targets != null ? var.scanning_configuration.container_targets : {}) : length(regexall("^ocid1.*$", t.target_registry.compartment_id)) > 0 ? t.target_registry.compartment_id : var.compartments_dependency[t.target_registry.compartment_id].id]) : []
}
data "oci_artifacts_container_repositories" "these" {
  for_each = toset(local.target_container_scan_cmps)
    compartment_id = each.key
}  

#-- Container targets
resource "oci_vulnerability_scanning_container_scan_target" "these" {
  for_each = var.scanning_configuration != null ? (var.scanning_configuration.container_targets != null ? var.scanning_configuration.container_targets : {}) : {}
    lifecycle {
      precondition {
        condition = length(data.oci_artifacts_container_repositories.these[length(regexall("^ocid1.*$", each.value.target_registry.compartment_id)) > 0 ? each.value.target_registry.compartment_id : var.compartments_dependency[each.value.target_registry.compartment_id].id].container_repository_collection[0].items) > 0
        error_message = "VALIDATION FAILURE: target compartment \"${length(regexall("^ocid1.*$", each.value.target_registry.compartment_id)) > 0 ? each.value.target_registry.compartment_id : var.compartments_dependency[each.value.target_registry.compartment_id].id}\" has no repositories. The Scanning Service requires pre-existing repositories in container scan target compartments."
      }
    }
    compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.scanning_configuration.default_compartment_id)) > 0 ? var.scanning_configuration.default_compartment_id : var.compartments_dependency[var.scanning_configuration.default_compartment_id].id)
    display_name = each.value.name
    description = each.value.description != null ? each.value.description : each.value.name
    container_scan_recipe_id   = length(regexall("^ocid1.*$", each.value.container_recipe_id)) > 0 ? each.value.container_recipe_id : oci_vulnerability_scanning_container_scan_recipe.these[each.value.container_recipe_id].id
    target_registry {
      compartment_id = length(regexall("^ocid1.*$", each.value.target_registry.compartment_id)) > 0 ? each.value.target_registry.compartment_id : var.compartments_dependency[each.value.target_registry.compartment_id].id
      type = upper(coalesce(each.value.target_registry.type,"OCIR"))
      repositories = each.value.target_registry.repositories
      url = each.value.target_registry.url
    }
    defined_tags  = each.value.defined_tags != null ? each.value.defined_tags : var.scanning_configuration.default_defined_tags
    freeform_tags = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.scanning_configuration.default_freeform_tags)
}

locals {
  target_host_scan_cmps = var.scanning_configuration != null ? ({for k,v in (var.scanning_configuration.host_targets != null ? var.scanning_configuration.host_targets : {}) : k => (length(regexall("^ocid1.*$", v.target_compartment_id)) > 0 ? v.target_compartment_id : var.compartments_dependency[v.target_compartment_id].id)}) : {}
  instances = flatten([
    for k, v in local.target_host_scan_cmps : [
      for i in data.oci_core_instances.these[k].instances : [{"id" : i.id, "compartment_id" : i.compartment_id}]
    ]  
  ])
  vss_plugin_state = flatten([
    for k, v in local.target_host_scan_cmps : [
      for i in data.oci_core_instances.these[k].instances : [
        #{"name" : i.display_name, "ocid" : i.id, "plugin_name" : data.oci_computeinstanceagent_instance_agent_plugins.these[i.id].name, "plugin_enabled" : i.agent_config[0].plugins_config[0].desired_state == "ENABLED" ? true : false, "plugin_status" : data.oci_computeinstanceagent_instance_agent_plugins.these[i.id].status, "plugin_message" : data.oci_computeinstanceagent_instance_agent_plugins.these[i.id].message} :
        {"instance_name" : i.display_name, "instance_ocid" : i.id, "instance_state": i.state, "is_cloud_agent_plugin_enabled" : (length(i.agent_config[0].plugins_config) > 0 ? (i.agent_config[0].plugins_config[0].desired_state == "ENABLED" ? true : false) : false), "reminder" : "Make sure the Vulnerability Scanning plugin is ENABLED and RUNNING."}
      ]
    ]
  ])
}

data "oci_core_instances" "these" {
  for_each = local.target_host_scan_cmps
    compartment_id = each.value
}

/*
data "oci_computeinstanceagent_instance_agent_plugin" "these" {
  for_each = {for i in local.instances : i.id => i.compartment_id}
    compartment_id = each.value
    instanceagent_id = each.key
    plugin_name = "Vulnerability Scanning"
}   */