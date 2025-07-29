# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_security_zones" {
  source                       = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/security_zones"
  tenancy_ocid                 = var.tenancy_ocid
  security_zones_configuration = var.security_zones_configuration
}
