# CIS OCI Cloud Guard Module Example

## Introduction

This example shows how to deploy Cloud Guard targets in OCI using the [Cloud Guard module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/cloud-guard/).

It enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region, and defines two targets. Both targets monitor compartments under *resource_ocid* compartment and are created in *resource_ocid* compartment. First target (*CLOUD-GUARD-TARGET-1*) uses Oracle provided recipes while the second one (*CLOUD-GUARD-TARGET-2*) uses cloned recipes.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *cloud_guard_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-TENANCY-OCID\>* placeholder by the tenancy OCID. 
   - Replace *\<REPLACE-BY-REPORTING-REGION-NAME\>* placeholder by the actual reporting region name.
   - Replace *\<REPLACE-BY-TARGET-COMPARTMENT-OCID\>* placeholders by the appropriate target compartment OCIDs. 

Refer to [Cloud Guard module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```