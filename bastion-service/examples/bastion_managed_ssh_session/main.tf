
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "bastion" {
  source = "../.."
  bastions_configuration = var.bastions_configuration
  sessions_configuration = var.sessions_configuration
}