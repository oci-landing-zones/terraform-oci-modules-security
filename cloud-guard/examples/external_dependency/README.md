# CIS OCI Cloud Guard Module Example - External Dependency

## Introduction

This example shows how to deploy Cloud Guard targets in OCI using the [Cloud Guard module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/cloud-guard/). It is functionally equivalent to [Vision example](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/cloud-guard/examples/vision), but it obtains its dependencies from OCI Object Storage object. 

The module enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region, and defines two targets. Both targets monitor compartments under *resource_ocid* compartment and are created in *resource_ocid* compartment. First target (*CLOUD-GUARD-TARGET-1*) uses Oracle provided recipes while the second one (*CLOUD-GUARD-TARGET-2*) uses cloned recipes.

Because it needs to read from OCI Object Storage, the following permissions are required for the executing user, in addition to the permissions required by the [Cloud Guard module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<bucket-name>'
```
Note: If deploying Cloud Guard in a stand alone case (without Core), this module requires the permissions below.

```
allow service cloudguard to manage cloudevents-rules in tenancy where target.rule.type='managed'
allow service cloudguard to use network-security-groups in tenancy
allow service cloudguard to read all-resources in tenancy

```


## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *cloud_guard_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-TENANCY-OCID\>* placeholder by the tenancy OCID. 
   - Replace *\<REPLACE-BY-REPORTING-REGION-NAME\>* placeholder by the actual reporting region name.
   - Replace *\<REPLACE-BY-TARGET-COMPARTMENT-REFERENCE\>* placeholders by the appropriate target compartment references, expected to be found in the OCI Object Storage object referred by *\<REPLACE-BY-OBJECT-NAME\>*. 
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholder by the OCI Object Storage bucket that contains the object referred by *\<REPLACE-BY-OBJECT-NAME\>*.
   - Replace *\<REPLACE-BY-OBJECT-NAME\>* placeholder by the OCI Object Storage object that has the compartment references. This object is supposedly stored on OCI Object Storage by the module that manages compartments.

The OCI Object Storage object is expected to have a structure like this:
```
{
  "HR-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
  "SALES-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...y2a"
  }
}
```

Note the compartment OCIDs are referred by *HR-CMP* and *SALES-CMP* keys. These are the values that should be used when replacing *\<REPLACE-BY-TARGET-COMPARTMENT-REFERENCE\>* placeholders.

Refer to [Cloud Guard module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```