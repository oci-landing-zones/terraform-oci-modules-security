# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

data "oci_cloud_guard_security_policies" "these" {
  compartment_id = var.security_zones_configuration != null ? var.tenancy_ocid : "__void__"
}

data "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id = var.security_zones_configuration != null ? var.tenancy_ocid : "__void__"
}