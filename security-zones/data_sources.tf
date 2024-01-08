# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_cloud_guard_security_policies" "these" {
  compartment_id = var.security_zones_configuration != null ? var.security_zones_configuration.tenancy_ocid : "void"
}

data "oci_cloud_guard_cloud_guard_configuration" "this" {
  compartment_id = var.security_zones_configuration != null ? var.security_zones_configuration.tenancy_ocid : "Void"
}