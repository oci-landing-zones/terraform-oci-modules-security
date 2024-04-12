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
  depends_on = [oci_cloud_guard_cloud_guard_configuration.this]  
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name = "OCI Configuration Detector Recipe"
}

data "oci_cloud_guard_detector_recipes" "threat" {
  depends_on = [oci_cloud_guard_cloud_guard_configuration.this]  
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name = "OCI Threat Detector Recipe"
}

data "oci_cloud_guard_detector_recipes" "activity" {
  depends_on = [oci_cloud_guard_cloud_guard_configuration.this]  
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name = "OCI Activity Detector Recipe"
}

data "oci_cloud_guard_responder_recipes" "responder" {
  depends_on = [oci_cloud_guard_cloud_guard_configuration.this]  
  compartment_id = var.cloud_guard_configuration != null ? var.tenancy_ocid : "__void__"
  display_name = "OCI Responder Recipe"
}