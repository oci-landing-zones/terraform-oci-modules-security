# Bastion with Port Forwarding Sessions Example 

## Introduction

This example shows how to deploy bastions and sessions in OCI using the [Bastion module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/bastion). It deploys one bastion and one port forwarding session. It outputs the connection string used to connect to target resource endpoint.

The following resources are created:

One bastion:
- of type "standard".
- maximum time to live sessions of three hours.

One port forwarding session:
- time to live of three hours.
- target resource endpoint of choice.

See [input.auto.tfvars.template](./input.auto.tfvars.template) for the variables configuration.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the input variables, by making the appropriate substitutions:
   - Replace \<REPLACE-BY-\*\> placeholders with appropriate values. 
   
Refer to [bastion module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```