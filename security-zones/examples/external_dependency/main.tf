# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count          = var.oci_compartments_dependency != null ? 1 : 0
  compartment_id = var.security_zones_configuration.tenancy_ocid
}

data "oci_objectstorage_object" "compartments" {
  count     = var.oci_compartments_dependency != null ? 1 : 0
  bucket    = var.oci_compartments_dependency.bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_compartments_dependency.object
}

module "vision_security_zones" {
  source                       = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/security_zones"
  tenancy_ocid                 = var.tenancy_ocid
  security_zones_configuration = var.security_zones_configuration
  enable_output                = true
  compartments_dependency      = var.oci_compartments_dependency != null ? jsondecode(data.oci_objectstorage_object.compartments[0].content) : null
}
