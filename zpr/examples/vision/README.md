# OCI Zero Trust Packet Routing Module Example

## Introduction
This example shows how to deploy ZPR resources in OCI using the [ZPR module](../..).

It defines a security attribute namespace, two security attributes (one for the created namespace, one for the default oracle-zpr namespace), and a ZPR policy with one policy statement. 

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *zpr_configuration* input variable, by making the appropriate substitutions:
    - Replace \*<REPLACE-BY-COMPARTMENT-OCID\>* placeholder by the appropriate compartment OCID.

Refer to [ZPR module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```
