# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  compartments_configuration = { 
    enable_delete = true
    compartments = {
      TOP-CMP = { 
        parent_id = "TENANCY-ROOT"
        name = "vss-cmp-composite-cmp", 
        description = "VSS cmp composite sample compartment"
      }
    }    
  }

  scanning_configuration = {
    default_compartment_id = module.compartments.compartments["TOP-CMP"].id
    host_recipes = {
      DEFAULT-RECIPE = {
        name = "vss-cmp-composite-recipe"
      }
    }
    host_targets = {
      CMP-TARGET = {
        name = "vss-cmp-composite-target"
        target_compartment_id = module.compartments.compartments["TOP-CMP"].id
        host_recipe_id = "DEFAULT-RECIPE"
      }
    }
  }
}

module "compartments" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/compartments"
  tenancy_ocid = var.tenancy_ocid
  compartments_configuration = local.compartments_configuration
}

module "vss" {
  source                  = "../.."
  scanning_configuration  = local.scanning_configuration
  enable_output           = true
}