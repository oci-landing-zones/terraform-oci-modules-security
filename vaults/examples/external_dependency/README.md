# CIS OCI Vaults Module Example - External Dependency

## Introduction

This example shows how to deploy Vaults and Keys in OCI using the [Vaults module](../..). It is functionally equivalent to [Vision example](../vision/), but it obtains its dependencies from OCI Object Storage objects, specified in *oci_compartments_dependency* and *oci_vaults_dependency* variables settings. 

It defines a vault and two keys.
- The vault (*VISION-VAULT*) is created in a shared HSM partition (per module default value). 
- Both keys are AES 32-byte keys protected by HSM (per module default values). 
- The first key (*VISION-BUCKET-KEY*) is created in the *VISION-VAULT*, per *vault_key* value. It is created in the same compartment as the vault, as it does not assign *compartment_id*. It is granted access by Object Storage service in Ashburn region and by *vision-appdev-admin-group* IAM group. It has been rotated twice, per *versions* setting. 
- The second key (*VISION-BLOCK-VOLUME-KEY*) is created in an externally managed Vault identified by *vault_management_endpoint* URL. It is created in the same compartment as *VISION-VAULT* vault, as it does not assign *compartment_id*. It is granted access by Block Storage service and by *vision-appdev-admin-group* IAM group. It hasn't been rotated.

Because it needs to read from OCI Object Storage, the following permissions are required for the executing user, in addition to the permissions required by the [Vaults module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<bucket-name>'
```

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *vaults_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-REFERENCE\>* placeholder by the appropriate compartment reference, expected to be found in the OCI Object Storage object referred by *\<REPLACE-BY-OBJECT-NAME\>* within the object pointed by oci_compartments_dependency.
   - Replace *\<REPLACE-BY-VAULT-MANAGEMENT-ENDPOINT-REFERENCE\>* by the appropriate vault reference, expected to be found in the OCI Object Storage object referred by *\<REPLACE-BY-OBJECT-NAME\>* within the object pointed by oci_vaults_dependency.  
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholders by the OCI Object Storage buckets that contain the object referred by *\<REPLACE-BY-OBJECT-NAME\>*.
   - Replace *\<REPLACE-BY-OBJECT-NAME\>* placeholders by the OCI Object Storage objects with the compartments and vaults references. These objects are supposedly stored in OCI Object Storage by the modules that manage compartments and vaults. 

The OCI Object Storage object with compartments dependencies (*oci_compartments_dependency*) is expected to have a structure like this:
```
{
  "SECURITY-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...utp"
  }
}
```

Note the compartment OCID is referred by *SECURITY-CMP* key. This is the value that should be used when replacing *\<REPLACE-BY-COMPARTMENT-REFERENCE\>* placeholder.

The OCI Object Storage object with vaults dependencies (*oci_vaults_dependency*) is expected to have a structure like this:
```
{
  "SHARED-VIRTUAL-PRIVATE-VAULT" : {
    "management_endpoint" : "https://dvs...lw...fe-management.kms.us-ashburn-1.oraclecloud.com"
  }
}
```

Note the management endpoint is referred by *SHARED-VIRTUAL-PRIVATE-VAULT* key. This is the value that should be used when replacing *\<REPLACE-BY-VAULT-MANAGEMENT-ENDPOINT-REFERENCE\>* placeholder.

Refer to [Vaults module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```