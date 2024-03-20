# CIS OCI Vaults Module Example

## Introduction

This example shows how to deploy Vaults and Keys in OCI using the [Vaults module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/vaults).

It defines a vault with two keys. The vault is created in a shared HSM partition. Both keys are AES 32-byte keys protected by HSM (per default values) and are created in the same compartment as the vault. The first key (*VISION-BUCKET-KEY*) is granted access by Object Storage service in Ashburn region and by *vision-appdev-admin-group* IAM group. Additionally, it has been rotated twice (per *versions* setting). The second key (*VISION-BLOCK-VOLUME-KEY*) is granted access by Block Storage service and by *vision-appdev-admin-group* IAM group. It hasn't been rotated.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *security_zones_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCID.iate compartment OCIDs. 

Refer to [Vaults module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```