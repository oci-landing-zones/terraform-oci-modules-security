# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_cloud_guard" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/cloud-guard"
  cloud_guard_configuration = var.cloud_guard_configuration
  tenancy_ocid = var.tenancy_ocid
  enable_output = true
}
