# CIS OCI Security Zones Module Example - External Dependency

## Introduction

This example shows how to deploy Security Zones in OCI using the [Security Zones module](../..). It is functionally equivalent to [Vision example](../vision/), but it obtains its dependencies from OCI Object Storage object, specified in *oci_compartments_dependency* variable settings. 

It enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region, and defines two recipes and one security zone. The recipes are stored in the same *compartment_id*. The first recipe (*CIS-L1-RECIPE*) is a CIS level 1 recipe (*cis_level = "1"*) while the second (*CIS-L2-RECIPE*) is a CIS level 2 recipe (*cis_level = "2"*). The security zone is defined for *compartment_id* and is associated with *CIS-l1-RECIPE*. *CIS-L2-RECIPE* is not associated with a security zone.

Because it needs to read from OCI Object Storage, the following permissions are required for the executing user, in addition to the permissions required by the [Security Zone module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<bucket-name>'
```

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *security_zones_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-TENANCY-OCID\>* placeholder by the tenancy OCID. 
   - Replace *\<REPLACE-BY-REPORTING-REGION-NAME\>* placeholder by the actual reporting region name. Example: "us-ashburn-1".
   - Replace *\<REPLACE-BY-SECURITY-ZONE-COMPARTMENT-REFERENCE\>* placeholder by the appropriate security zone compartment reference, expected to be found in the OCI Object Storage object referred by *\<REPLACE-BY-OBJECT-NAME\>*. 
   - Replace *\<REPLACE-BY-SECURITY-ZONE-RECIPE-COMPARTMENT-REFERENCE\>* placeholders by the appropriate security zone recipe compartment references, expected to be found in the OCI Object Storage object referred by *\<REPLACE-BY-OBJECT-NAME\>*.
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholder by the OCI Object Storage bucket that contains the object referred by *\<REPLACE-BY-OBJECT-NAME\>*.
   - Replace *\<REPLACE-BY-OBJECT-NAME\>* placeholder by the OCI Object Storage object that has the compartment references. This object is supposedly stored on OCI Object Storage by the module that manages compartments.

The OCI Object Storage object is expected to have a structure like this:
```
{
  "CIS-LANDING-ZONE-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
}
```

Note the compartment OCID is referred by *CIS-LANDING-ZONE-CMP* key. This is the value that should be used when replacing *\<REPLACE-BY-SECURITY-ZONE-COMPARTMENT-REFERENCE\>* and *\<REPLACE-BY-SECURITY-ZONE-RECIPE-COMPARTMENT-REFERENCE\>* placeholders.

Refer to [Security Zone module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```