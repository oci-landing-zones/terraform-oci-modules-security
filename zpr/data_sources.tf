data "oci_identity_regions" "these" {}

data "oci_zpr_configuration" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_security_attribute_security_attribute_namespaces" "default_security_attribute_namespaces" {
  compartment_id = var.tenancy_ocid
  name           = "oracle-zpr"

  depends_on = [time_sleep.wait_after_zpr_configuration]
}

data "oci_security_attribute_security_attribute_namespaces" "query_security_attribute_namespaces" {
  for_each       = { for attribute_key, attribute_value in var.zpr_configuration.security_attributes : attribute_key => attribute_value if(attribute_value.namespace_id != null) }
  compartment_id = var.tenancy_ocid
  name           = each.value.namespace_id

  depends_on = [time_sleep.wait_after_zpr_configuration]
}