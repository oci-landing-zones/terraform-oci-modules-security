# OCI Vulnerability Scanning Module Example - External Dependency

## Introduction

This example shows how to deploy Vulnerability Scanning resources in OCI using the [VSS module](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/vss). It is functionally equivalent to [Vision example](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/tree/main/vss/examples/vision), but it obtains its dependencies from OCI Object Storage objects, specified in *oci_compartments_dependency* and *oci_vaults_dependency* variables settings. 

It defines a host recipe (*VISION-HOST-RECIPE*), a host target (*VISION-HOST-TARGET*), a container recipe (*VISION-CONTAINER-RECIPE*) and a container target (*VISION-CONTAINER-TARGET*), all created in the same compartment defined by *default_compartment_ocid*. The example uses module defaults and only defines the minimum required attributes. *VISION-HOST-RECIPE* recipe is used by *VISION-HOST-TARGET* target, while *VISION-CONTAINER-RECIPE* recipe is used by *VISION-CONTAINER-TARGET* target.

Because it needs to read from OCI Object Storage, the following permissions are required for the executing user, in addition to the permissions required by the [VSS module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<bucket-name>'
```

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *security_zones_configuration* input variable, by making the appropriate substitutions:
   - Replace \*<REPLACE-BY-COMPARTMENT-REFERENCE\>* placeholder by the appropriate compartment reference, expected to be found in the OCI Object Storage object named *\<REPLACE-BY-OBJECT-NAME\>* in *oci_compartments_dependency*.
   - Replace \*<REPLACE-BY-TARGET-COMPARTMENT-REFERENCE\>* placeholder by the appropriate target compartment reference, expected to be found in the OCI Object Storage object named *\<REPLACE-BY-OBJECT-NAME\>* in *oci_compartments_dependency*.
   - Replace \*<REPLACE-BY-TARGET-REGISTRY-COMPARTMENT-REFERENCE\>* placeholder by the appropriate target registry compartment reference, expected to be found in the OCI Object Storage object named *\<REPLACE-BY-OBJECT-NAME\>* in *oci_compartments_dependency*.
   - Replace *\<REPLACE-BY-BUCKET-NAME\>* placeholder by the OCI Object Storage bucket that contains the object named *\<REPLACE-BY-OBJECT-NAME\>*.
   - Replace *\<REPLACE-BY-OBJECT-NAME\>* placeholder by the OCI Object Storage object with the compartments references. This object is tipically stored in OCI Object Storage by the module that manages compartments.

The OCI Object Storage object with compartments dependencies (*oci_compartments_dependency*) is expected to have a structure like this:
```
{
  "SECURITY-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
  "APPLICATION-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...zrt"
  }
}
```

Note the compartment OCIDs are referred by *SECURITY-CMP* and *APPLICATION-CMP* keys. These are the values that should be used when replacing *\<REPLACE-BY-COMPARTMENT-REFERENCE\>*, \*<REPLACE-BY-TARGET-COMPARTMENT-REFERENCE\>* and  \*<REPLACE-BY-TARGET-REGISTRY-COMPARTMENT-REFERENCE\>* placeholders.

Refer to [VSS module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```
