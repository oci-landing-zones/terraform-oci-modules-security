data "oci_identity_regions" "these" {}


data "oci_zpr_configuration" "this" {
  compartment_id = var.tenancy_ocid
}