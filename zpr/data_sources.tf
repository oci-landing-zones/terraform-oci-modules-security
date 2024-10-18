data "oci_identity_regions" "these" {}

data "oci_zpr_configuration" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_security_attribute_security_attribute_namespaces" "default_security_attribute_namespaces"{
  compartment_id = var.tenancy_ocid
  name = "oracle-zpr"
  depends_on = [ resource.oci_zpr_configuration.this ]
}