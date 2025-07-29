# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_vaults" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/vaults"
  providers = {
    oci      = oci
    oci.home = oci.home
  }
  vaults_configuration = var.vaults_configuration
}
