
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "bastion" {
  source                 = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/bastion"
  bastions_configuration = var.bastions_configuration
  sessions_configuration = var.sessions_configuration
}