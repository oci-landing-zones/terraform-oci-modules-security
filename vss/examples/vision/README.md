# CIS OCI Vulnerability Scanning Module Example

## Introduction

This example shows how to deploy Vulnerability Scanning resources in OCI using the [VSS module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/vss).

It defines a host recipe (*VISION-HOST-RECIPE*), a host target (*VISION-HOST-TARGET*), a container recipe (*VISION-CONTAINER-RECIPE*) and a container target (*VISION-CONTAINER-TARGET*), all created in the same compartment defined by *default_compartment_ocid*. The example uses module defaults and only defines the minimum required attributes.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *security_zones_configuration* input variable, by making the appropriate substitutions:
   - Replace \*<REPLACE-BY-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCID. 
   - Replace \*<REPLACE-BY-TARGET-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCID. 
   - Replace \*<REPLACE-BY-TARGET-REGISTRY-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCIDs, where images registries are stored.

Refer to [VSS module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```