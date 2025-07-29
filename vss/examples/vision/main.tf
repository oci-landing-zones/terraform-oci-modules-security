# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_scanning" {
  #source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/vss"
  source                 = "../.."
  scanning_configuration = var.scanning_configuration
}
