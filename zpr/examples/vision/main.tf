module "vision_zpr" {
  source = "../../"
  tenancy_ocid = var.tenancy_ocid
  zpr_configuration = var.zpr_configuration
}