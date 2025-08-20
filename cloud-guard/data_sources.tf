# Copyright (c) 2023, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

data "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
}

data "oci_cloud_guard_detector_recipes" "configuration" {
  depends_on     = [oci_cloud_guard_cloud_guard_configuration.this]
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name   = "OCI Configuration Detector Recipe"
}

data "oci_cloud_guard_detector_recipes" "threat" {
  depends_on     = [oci_cloud_guard_cloud_guard_configuration.this]
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name   = "OCI Threat Detector Recipe"
}

data "oci_cloud_guard_detector_recipes" "activity" {
  depends_on     = [oci_cloud_guard_cloud_guard_configuration.this]
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name   = "OCI Activity Detector Recipe"
}

data "oci_cloud_guard_responder_recipes" "responder" {
  depends_on     = [oci_cloud_guard_cloud_guard_configuration.this]
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name   = "OCI Responder Recipe"
}

data "oci_cloud_guard_targets" "these" {
  for_each = try(var.cloud_guard_configuration.targets, {})
  #-- If target_resource_type is null or target_resource_type == "COMPARTMENT", the compartment_id defaults to target_resource_id.
  compartment_id = each.value.resource_type != null ? (each.value.resource_type == "COMPARTMENT" ? (length(regexall("^ocid1.*$", each.value.resource_id)) > 0 ? each.value.resource_id : (upper(each.value.resource_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[each.value.resource_id].id)) : (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : (upper(each.value.compartment_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[each.value.compartment_id].id))) : (length(regexall("^ocid1.*$", each.value.resource_id)) > 0 ? each.value.resource_id : (upper(each.value.resource_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[each.value.resource_id].id))
}