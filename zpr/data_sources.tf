data "oci_identity_regions" "these" {}

data "oci_zpr_configuration" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_security_attribute_security_attribute_namespaces" "default_security_attribute_namespaces"{
  compartment_id = var.tenancy_ocid
  name = "oracle-zpr"
  depends_on = [ resource.oci_zpr_configuration.this ]
}

data "oci_security_attribute_security_attribute_namespaces" "query_security_attribute_namespaces"{
  for_each = var.zpr_configuration.security_attributes
    compartment_id = var.tenancy_ocid
    name = each.value.namespace_id != null ? each.value.namespace_id : "oracle-zpr"
    depends_on = [ resource.oci_zpr_configuration.this ]
} 