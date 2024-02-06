# CIS Bastion and Port Forwarding Example 

## Introduction

This example shows how to deploy Bastions and Sessions in OCI using the [cis-bastion module](../../). It deploys one Bastion Service and one Managed SSH connection.
This code will generate an output with the connection string that will be used to connect to target resource.


For Bastions:
- The Bastion will have standard type.
- The Bastion will have the external DNS enabled.
- The Bastion will have the maximum time to live session to 3h.

For Sessions:
- The session type will be PORT_FORWARDING.
- The session time to live is set to 3h.
- The session will be created on the bastion1.

See [input.auto.tfvars.template](./input.auto.tfvars.template) for the variables configuration.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the input variables, by making the appropriate substitutions:
   - Replace \<REPLACE-BY-\*\> placeholders with appropriate values. 
   
Refer to [cis-bastion module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```