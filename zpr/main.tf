resource "oci_zpr_configuration" "this" {
  count          = data.oci_zpr_configuration.this.zpr_status == "DISABLED" ? 1 : 0
  compartment_id = var.tenancy_ocid
  defined_tags   = var.zpr_configuration.default_defined_tags
  freeform_tags  = var.zpr_configuration.default_freeform_tags
  zpr_status     = "ENABLED"
}

resource "oci_security_attribute_security_attribute_namespace" "these" {
  for_each       = var.zpr_configuration.namespaces != null ? var.zpr_configuration.namespaces : {}
  compartment_id = each.value.compartment_id
  description    = each.value.description
  name           = each.value.name

  #Optional
  defined_tags  = each.value.defined_tags != null ? each.value.defined_tags : var.zpr_configuration.default_defined_tags
  freeform_tags = each.value.freeform_tags != null ? each.value.freeform_tags : var.zpr_configuration.default_freeform_tags
}

resource "oci_security_attribute_security_attribute" "these" {
  #Required
  for_each                        = var.zpr_configuration.security_attributes != null ? var.zpr_configuration.security_attributes : {}
  description                     = each.value.description
  name                            = each.value.name
  security_attribute_namespace_id = each.value.namespace_id != null ? each.value.namespace_id : each.value.namespace_key != null ? oci_security_attribute_security_attribute_namespace.these[each.value.namespace_key].id : "oracle-zpr"
  #Optional
  validator {
    validator_type = each.value.validator_values != null ? "ENUM" : null
    values         = each.value.validator_values
  }
}

resource "oci_zpr_zpr_policy" "these" {
  for_each       = var.zpr_configuration.zpr_policies != null ? var.zpr_configuration.zpr_policies : {}
  compartment_id = var.tenancy_ocid
  description    = each.value.description
  name           = each.value.name
  statements     = each.value.statements
  #Optional
  defined_tags  = each.value.defined_tags != null ? each.value.defined_tags : var.zpr_configuration.default_defined_tags
  freeform_tags = each.value.freeform_tags != null ? each.value.freeform_tags : var.zpr_configuration.default_freeform_tags
}