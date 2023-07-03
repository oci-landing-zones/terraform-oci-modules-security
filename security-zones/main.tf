# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  # Security Zone recipes aligned to CIS 1.2 Level 1
  cis_1_2_l1_policy_names = ["deny public_buckets", "deny db_instance_public_access"]
  # Security Zone recipes aligned to CIS 1.2 Level 2
  cis_1_2_l2_policy_names = ["deny block_volume_without_vault_key", "deny boot_volume_without_vault_key", "deny buckets_without_vault_key", "deny file_system_without_vault_key"]

  sz_policies = {for policy in data.oci_cloud_guard_security_policies.these.security_policy_collection[0].items : policy.friendly_name => policy.id}

  cis_1_2_l1_policy_ocids = [for name in local.cis_1_2_l1_policy_names : local.sz_policies[name]]
  cis_1_2_l2_policy_ocids = [for name in local.cis_1_2_l2_policy_names : local.sz_policies[name]]

  # For reference, below are the OCIDs for the policy names above in commercial realm regions
  # CIS 1.2 Level 1
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaa5ocyo7jqjzgjenvccch46buhpaaofplzxlp3xbxfcdwwk2tyrwqa"
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaauoi2xnbusvfd4yffdjaaazk64gndp4flumaw3r7vedwndqd6vmrq"
  # CIS 1.2 Level 2
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaa7pgtjyod3pze6wuylgmts6ensywmeplabsxqq2bk4ighps4fqq4a"
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaaxxs63ulmtcnxqmcvy6eaozh5jdtiaa2bk7wll5bbdsbnmmoczp5a"
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaaqmq4jqcxqbjj5cjzb7t5ira66dctyypq2m2o4psxmx6atp45lyda"
  # "ocid1.securityzonessecuritypolicy.oc1..aaaaaaaaff6n52aojbgdg46jpm3kn7nizmh6iwvr7myez7svtfxsfs7irigq"

  is_cloud_guard_enabled = data.oci_cloud_guard_cloud_guard_configuration.this.status == "ENABLED" ? true : length(oci_cloud_guard_cloud_guard_configuration.this) > 0 ? (oci_cloud_guard_cloud_guard_configuration.this[0].status == "ENABLED" ? true : false) : false
}

resource "oci_cloud_guard_cloud_guard_configuration" "this" {
  lifecycle {
    precondition {
      condition = data.oci_cloud_guard_cloud_guard_configuration.this.status == "ENABLED" ? true : var.security_zones_configuration.reporting_region != null ? true : false
      error_message = "VALIDATION FAILURE: reporting_region must be provided when enabling Cloud Guard."
    }
  }  
  count = data.oci_cloud_guard_cloud_guard_configuration.this.status == "DISABLED" ? 1 : 0 # we only manage this resource if Cloud Guard is currently disabled, which means we have to enable it.
    compartment_id        = var.security_zones_configuration.tenancy_ocid
    reporting_region      = var.security_zones_configuration.reporting_region
    status                = "ENABLED"
    self_manage_resources = var.security_zones_configuration.self_manage_resources != null ? (var.security_zones_configuration.self_manage_resources == true ? true : false) : false
}

resource "oci_cloud_guard_security_recipe" "these" {
  for_each = var.security_zones_configuration.recipes != null ? var.security_zones_configuration.recipes : {}
    compartment_id    = length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id
    display_name      = each.value.name
    description       = each.value.description != null ? each.value.description : each.value.name
    security_policies = coalesce(each.value.cis_level, var.security_zones_configuration.default_cis_level, "1") == "1" ?  setunion(local.cis_1_2_l1_policy_ocids, coalesce(each.value.security_policies_ocids, var.security_zones_configuration.default_security_policies_ocids, [])) : setunion(local.cis_1_2_l2_policy_ocids, local.cis_1_2_l1_policy_ocids, coalesce(each.value.security_policies_ocids, var.security_zones_configuration.default_security_policies_ocids, []))
    defined_tags      = each.value.defined_tags != null ? each.value.defined_tags : var.security_zones_configuration.default_defined_tags
    freeform_tags     = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.security_zones_configuration.default_freeform_tags)
}

resource "oci_cloud_guard_security_zone" "these" {
  for_each = var.security_zones_configuration.security_zones
    compartment_id    = length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id
    display_name            = each.value.name
    description             = each.value.description != null ? each.value.description : each.value.name
    security_zone_recipe_id = oci_cloud_guard_security_recipe.these[each.value.recipe_key].id
    defined_tags            = each.value.defined_tags != null ? each.value.defined_tags : var.security_zones_configuration.default_defined_tags
    freeform_tags           = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.security_zones_configuration.default_freeform_tags)
}    