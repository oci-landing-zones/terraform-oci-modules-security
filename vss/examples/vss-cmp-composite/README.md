# CIS OCI Vulnerability Scanning Module Example - VSS/Compartments Composite

## Introduction

This example shows how to deploy Vulnerability Scanning resources in OCI using the [VSS module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/vss). It deploys a sample compartment and the VSS resources in the same configuration. The intent here is showing how the output of the compartments module is used as an input in *scanning_configuration* variable. See in [main.tf](./main.tf) how both *compartments_configuration* and *scanning_configuration* variables are defined.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```