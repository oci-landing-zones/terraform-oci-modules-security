# check the status of zpr in tenancy by using datasource
resource "oci_zpr_configuration" "this" {
  count = data.oci_zpr_configuration.this.zpr_status == "DISABLED" ? 1 : 0
  compartment_id = var.tenancy_ocid

  defined_tags = {"Operations.CostCenter"= "42"}
  freeform_tags = {"Department"= "Finance"}
  zpr_status = "ENABLE"
}

resource "oci_security_attribute_security_attribute_namespace" "these" {
  #Required
  compartment_id = var.compartment_id
  description = var.security_attribute_namespace_description
  name = var.security_attribute_namespace_name

  #Optional
  defined_tags = {"Operations.CostCenter"= "42"}
  freeform_tags = {"Department"= "Finance"}
}

resource "oci_security_attribute_security_attribute" "these" {
  #Required
  description = var.security_attribute_description
  name = var.security_attribute_name
  security_attribute_namespace_id = oci_security_attribute_security_attribute_namespace.test_security_attribute_namespace.id

  #Optional
  validator {
    #Required
    validator_type = var.security_attribute_validator_validator_type

    #Optional
    values = var.security_attribute_validator_values
  }
}

resource "oci_zpr_zpr_policy" "these" {
  #Required
  compartment_id = var.tenancy_ocid
  description = var.zpr_policy_description
  name = var.zpr_policy_name
  statements = var.zpr_policy_statements

  #Optional
  defined_tags = {"Operations.CostCenter"= "42"}
  freeform_tags = {"Department"= "Finance"}
}