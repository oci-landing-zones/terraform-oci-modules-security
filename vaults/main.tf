# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  keys_policies = flatten([
    for key_key, key_value in(var.vaults_configuration != null ? (var.vaults_configuration.keys != null ? var.vaults_configuration.keys : {}) : {}) : {
      key            = key_key
      compartment_id = key_value.compartment_id != null ? (length(regexall("^ocid1.*$", key_value.compartment_id)) > 0 ? key_value.compartment_id : var.compartments_dependency[key_value.compartment_id].id) : (length(regexall("^ocid1.*$", var.vaults_configuration.default_compartment_id)) > 0 ? var.vaults_configuration.default_compartment_id : var.compartments_dependency[var.vaults_configuration.default_compartment_id].id)
      name           = "${key_value.name}-policy"
      description    = "CIS Landing Zone policy allowing access to ${key_value.name} Key in the Vault service."
      statements = concat(key_value.service_grantees != null ? [for sg in key_value.service_grantees : "Allow service ${sg} to use keys in compartment ${data.oci_identity_compartment.managed_keys[key_key].name} where target.key.id = '${oci_kms_key.these[key_key].id}'"] : [],
      key_value.group_grantees != null ? [for gg in key_value.group_grantees : "Allow group ${gg} to use key-delegate in compartment ${data.oci_identity_compartment.managed_keys[key_key].name} where target.key.id = '${oci_kms_key.these[key_key].id}'"] : [])
      defined_tags  = key_value.defined_tags != null ? key_value.defined_tags : var.vaults_configuration.default_defined_tags
      freeform_tags = merge(local.cislz_module_tag, key_value.freeform_tags != null ? key_value.freeform_tags : key_value.freeform_tags != null ? key_value.freeform_tags : var.vaults_configuration.default_freeform_tags)
    }
  ])

  keys_versions = flatten([
    for key_key, key_value in(var.vaults_configuration != null ? (var.vaults_configuration.keys != null ? var.vaults_configuration.keys : {}) : {}) : [
      for version in(key_value.versions != null ? key_value.versions : []) : {
        key_key     = key_key
        version_key = "${key_key}.${version}"
      }
    ]
  ])

  algorithms = ["AES", "RSA", "ECDSA"]
}

#-- Used for retrieving the compartment name to use in policy statements
data "oci_identity_compartment" "managed_keys" {
  provider = oci.home
  for_each = { for k, v in(var.vaults_configuration != null ? (var.vaults_configuration.keys != null ? var.vaults_configuration.keys : {}) : {}) : k => { compartment_id = v.compartment_id != null ? (length(regexall("^ocid1.*$", v.compartment_id)) > 0 ? v.compartment_id : var.compartments_dependency[v.compartment_id].id) : (length(regexall("^ocid1.*$", var.vaults_configuration.default_compartment_id)) > 0 ? var.vaults_configuration.default_compartment_id : var.compartments_dependency[var.vaults_configuration.default_compartment_id].id) } }
  id       = each.value.compartment_id
}

resource "oci_kms_vault" "these" {
  provider       = oci
  for_each       = var.vaults_configuration != null ? (var.vaults_configuration.vaults != null ? var.vaults_configuration.vaults : {}) : {}
  compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.vaults_configuration.default_compartment_id)) > 0 ? var.vaults_configuration.default_compartment_id : var.compartments_dependency[var.vaults_configuration.default_compartment_id].id)
  display_name   = each.value.name
  vault_type     = upper(coalesce(each.value.type, "DEFAULT"))
  defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.vaults_configuration.default_defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.vaults_configuration.default_freeform_tags)
}

resource "oci_kms_key" "these" {
  provider = oci
  #-- create_before_destroy makes Terraform to first update any resources that depend on these keys before destroying the keys.
  #-- This helps with Object Storage encrypted buckets, when updated with a new encryption key.
  lifecycle {
    create_before_destroy = true
    precondition {
      condition     = contains(local.algorithms, upper(coalesce(each.value.algorithm, "AES")))
      error_message = "VALIDATION FAILURE : \"${upper(coalesce(each.value.algorithm, "AES"))}\" value is invalid for \"algorithm\" attribute in ${each.key} key definition. Valid values are ${join(", ", local.algorithms)} (case insensitive)."
    }
    precondition {
      condition     = each.value.vault_key != null || each.value.vault_management_endpoint != null
      error_message = "VALIDATION FAILURE : either vault_key or vault_management_endpoint must be provided. Otherwise it is not possible to know which vault the key belongs to."
    }
  }
  for_each            = var.vaults_configuration != null ? (var.vaults_configuration.keys != null ? var.vaults_configuration.keys : {}) : {}
  compartment_id      = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.vaults_configuration.default_compartment_id)) > 0 ? var.vaults_configuration.default_compartment_id : var.compartments_dependency[var.vaults_configuration.default_compartment_id].id)
  display_name        = each.value.name
  management_endpoint = each.value.vault_management_endpoint != null ? length(regexall("^https://.*$", each.value.vault_management_endpoint)) > 0 ? each.value.vault_management_endpoint : var.vaults_dependency[each.value.vault_management_endpoint].management_endpoint : oci_kms_vault.these[each.value.vault_key].management_endpoint
  protection_mode     = upper(coalesce(each.value.protection_mode, "HSM"))
  key_shape {
    algorithm = upper(coalesce(each.value.algorithm, "AES"))
    length    = coalesce(each.value.length, 32)
    curve_id  = each.value.curve_id
  }
  auto_key_rotation_details {
    last_rotation_message     = each.value.last_rotation_message
    last_rotation_status      = each.value.last_rotation_status
    rotation_interval_in_days = each.value.rotation_interval_in_days
    time_of_last_rotation     = each.value.time_of_last_rotation
    time_of_next_rotation     = each.value.time_of_next_rotation
    time_of_schedule_start    = each.value.time_of_schedule_start
  }
  is_auto_rotation_enabled = each.value.is_auto_rotation_enabled != null ? each.value.is_auto_rotation_enabled : false
  defined_tags             = each.value.defined_tags != null ? each.value.defined_tags : var.vaults_configuration.default_defined_tags
  freeform_tags            = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.vaults_configuration.default_freeform_tags)
}

resource "oci_kms_key_version" "these" {
  provider = oci
  lifecycle {
    create_before_destroy = true
  }
  for_each = { for version in local.keys_versions : version.version_key => { key_id = oci_kms_key.these[version.key_key].id,
  management_endpoint = oci_kms_key.these[version.key_key].management_endpoint } }
  key_id              = each.value.key_id
  management_endpoint = each.value.management_endpoint
}

resource "oci_identity_policy" "managed_keys" {
  provider = oci.home
  lifecycle {
    create_before_destroy = true
  }
  for_each = { for k in local.keys_policies : k.key => { compartment_id = k.compartment_id,
    name         = k.name,
    description  = k.description,
    statements   = k.statements,
    defined_tags = k.defined_tags,
  freeform_tags = k.freeform_tags } if length(k.statements) > 0 }
  name           = each.value.name
  description    = each.value.description
  compartment_id = each.value.compartment_id
  statements     = each.value.statements
  defined_tags   = each.value.defined_tags
  freeform_tags  = each.value.freeform_tags
}

#-- Used for retrieving the compartment name to use in policy statements
data "oci_identity_compartment" "existing_keys" {
  provider = oci.home
  for_each = var.vaults_configuration != null ? (var.vaults_configuration.existing_keys_grants != null ? var.vaults_configuration.existing_keys_grants : {}) : {}
  id       = each.value.compartment_ocid
}

resource "oci_identity_policy" "existing_keys" {
  provider       = oci.home
  for_each       = var.vaults_configuration != null ? (var.vaults_configuration.existing_keys_grants != null ? var.vaults_configuration.existing_keys_grants : {}) : {}
  name           = "${lower(each.key)}-policy"
  description    = "CIS Landing Zone policy allowing access to keys in the Vault service."
  compartment_id = length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id
  statements = concat(
    each.value.service_grantees != null ? [for sg in each.value.service_grantees : "Allow service ${sg} to use keys in compartment ${data.oci_identity_compartment.existing_keys[each.key].name} where target.key.id = '${length(regexall("^ocid1.*$", each.value.key_id)) > 0 ? each.value.key_id : var.vaults_dependency[each.value.key_id].id}'"] : [],
  each.value.group_grantees != null ? [for gg in each.value.group_grantees : "Allow group ${gg} to use key-delegate in compartment ${data.oci_identity_compartment.existing_keys[each.key].name} where target.key.id = '${length(regexall("^ocid1.*$", each.value.key_id)) > 0 ? each.value.key_id : var.vaults_dependency[each.value.key_id].id}'"] : [])
  defined_tags  = var.vaults_configuration.default_defined_tags
  freeform_tags = merge(local.cislz_module_tag, var.vaults_configuration.default_freeform_tags)
}

resource "oci_kms_vault_replication" "these" {
  for_each = { for k, v in var.vaults_configuration != null ? var.vaults_configuration.vaults : {} : k => v
    if v.replica_region != null
  }
  vault_id       = oci_kms_vault.these[each.key].id
  replica_region = each.value.replica_region
}
