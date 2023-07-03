# CIS OCI Security Zones Module Example

## Introduction

This example shows how to deploy Security Zones in OCI using the [Security Zones module](../..).

It enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region, and defines two recipes and one security zone. The recipes are stored in the same *compartment_ocid*. The first recipe (*CIS-L1-RECIPE*) is a CIS level 1 recipe (*cis_level = "1"*) while the second (*CIS-L2-RECIPE*) is a CIS level 2 recipe (*cis_level = "2"*). The security zone is defined for *compartment_ocid* and is associated with *CIS-l1-RECIPE*. *CIS-L2-RECIPE* is not associated with a security zone.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *security_zones_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-TENANCY-OCID\>* placeholder by the tenancy OCID. 
   - Replace *\<REPLACE-BY-SECURITY-ZONE-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCID. 
   - Replace *\<REPLACE-BY-SECURITY-ZONE-RECIPE-COMPARTMENT-OCID\>* placeholders by the appropriate compartment OCIDs. 

Refer to [Security Zones module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```