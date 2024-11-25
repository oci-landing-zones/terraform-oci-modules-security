# CIS OCI Landing Zone Cloud Guard Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Cloud Guard service settings in Oracle Cloud Infrastructure (OCI) based on a single configuration object. OCI Cloud Guard helps customers monitor, identify, achieve, and maintain a strong security posture on Oracle Cloud. Use the service to examine your OCI resources for security weaknesses related to configuration, and your OCI operators and users for risky activities. Upon detection, Cloud Guard can suggest, assist, or take corrective actions, based on your configuration.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for fully runnable examples.

- [Requirements](#requirements)
- [How to Invoke the Module](#invoke)
- [Module Functioning](#functioning)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>

### Terraform Version >= 1.3.0
This module requires Terraform binary version 1.3.0 or greater, as it relies on Optional Object Type Attributes feature.
The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a
default value for any missing optional attributes.

### IAM Permissions

This module requires the following OCI IAM permission:

```
allow group <group> to manage cloud-guard-family in tenancy
```

## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "cloud_guard" {
  source = "../.."
  cloud_guard_configuration = var.cloud_guard_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the Cloud Guard module folder in this repository, as shown:
```
module "cloud_guard" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/cloud-guard"
  cloud_guard_configuration = var.cloud_guard_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security//cloud_guard?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

In this module, Cloud Guard settings are defined using the *cloud_guard_configuration* object, that supports the following attributes:
- **default_defined_tags**: (optional) the default defined tags that are applied to all resources managed by this module. It can be overridden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: (optional) the default freeform tags that are applied to all resources managed by this module. It can be overridden by *freeform_tags* attribute in each resource.
- **reporting_region**: (optional) the Cloud Guard reporting region, where all API calls, except reads, are made on. You can choose the reporting region among the available regions when enabling Cloud Guard. After Cloud Guard is enabled, you cannot change the reporting region without disabling and re-enabling Cloud Guard. Setting this attribute is required if Cloud Guard is enabled by this module. It defaults to tenancy home region if undefined.
- **self_manage_resources**: (optional) whether Oracle managed resources are created by customers. Default: false.
- **cloned_recipes_prefix**: (optional) a prefix to cloned recipe names. Default: "oracle-cloned-".
- **ignore_existing_targets**: (optional) whether to check if targets being requested already exist, a scenario that would make OCI to report an error during terraform apply, as only one target is allowed per target "COMPARTMENT" type. Default is false. When set to true, the module ignores the particular requested target if there is already a target defined for the specific compartment.
- **targets**: (optional) the Cloud Guard targets.

**Note**: The module enables the Cloud Guard service in the tenancy if Cloud Guard is not enabled. **It will not disable Cloud Guard under any circumstances**. For disabling Cloud Guard, use the OCI Console.

### Defining Cloud Guard Targets

Within *cloud_guard_configuration*, use the *targets* attribute to define Cloud Guard targets. Each target is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *targets* attribute supports the following attributes:
- **name**: (required) the target name.
- **resource_id**: (required) the resource that Cloud Guard monitors. If the resource refers to a compartment, Cloud Guard monitors the compartment and all its subcompartments. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **compartment_id**: (optional) the compartment where the target is created. It defaults to the value of *resource_id* if *resource_type* is "COMPARTMENT". This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **resource_type**: (optional) the resource type that Cloud Guard monitors. Valid values: "COMPARTMENT", "FACLOUD". Default: "COMPARTMENT".
- **use_cloned_recipes**: (optional) whether the target should use clones of Oracle provided recipes. Default: false, which means targets use the Oracle provided recipes by default.  
- **defined_tags**: (optional) the target defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (optional) the target freeform tags. *default_freeform_tags* is used if undefined.

**Note**: Regardless of using Oracle provided or cloned recipes, every Cloud Guard target gets configuration, activity and threat detector recipes as well as a responder recipe.

## An Example

The following snippet enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region and defining two targets. Both targets monitor compartments under *resource_id* compartment and are created in *resource_id* compartment. First target (*CLOUD-GUARD-TARGET-1*) uses Oracle provided recipes while the second one (*CLOUD-GUARD-TARGET-2*) uses cloned recipes.
```
cloud_guard_configuration = {
  reporting_region = "us-ashburn-1" # It defaults to tenancy home region if undefined.
  
  targets = {
    CLOUD-GUARD-TARGET-1 = {
      name = "vision-cloud-guard-target-1"
      resource_id = "ocid1.compartment.oc1..aaaaaa...xuq"
    }  
    CLOUD-GUARD-TARGET-2 = {
      name = "vision-cloud-guard-target-1"
      resource_id = "ocid1.compartment.oc1..aaaaaa...y2a"
      use_cloned_recipes = true
    }
  }
}
```
### <a name="ext_dep">External Dependencies</a>

The example above has some dependencies. Specifically, it requires *tenancy_ocid* and *resource_id* values. These values need to be obtained somehow. In some cases, you can simply get them from the team that is managing compartments and operate on a manual copy-and-paste fashion. However, in the automation world, copying and pasting can be slow and error prone. More sophisticated automation approaches would get these dependencies from their producing Terraform configurations. With this scenario in mind, **the module overloads the attributes ending in *_id***. The *\*_id* attributes can be assigned a literal OCID (as in the example above, for those whom copying and pasting is an acceptable approach) or a reference (a key) to an OCID. If a key to an OCID is given, the module requires a map of objects where the key and the OCID are expected to be found. This map of objects is passed to the module via the *compartments_dependency* variable. 

**Note**: The special key "TENANCY-ROOT" is reserved and should be used for referring to the tenancy OCID in *resource_id* and *compartment_id* attributes.

Rewriting the example above with the external dependency:

```
cloud_guard_configuration = {
  reporting_region = "us-ashburn-1" # It defaults to tenancy home region if undefined.
  
  targets = {
    CLOUD-GUARD-TARGET-1 = {
      name = "vision-cloud-guard-target-1"
      resource_id = "HR-CMP"
    }  
    CLOUD-GUARD-TARGET-2 = {
      name = "vision-cloud-guard-target-1"
      resource_id = "SALES-CMP"
      use_cloned_recipes = true
    }
  }
}

compartments_dependency = {
  "HR-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
  "SALES-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...y2a"
  }
}
```

The example now relies on references to compartments (*HR-CMP* and *SALES-CMP* keys) rather than the literal compartment OCIDs. Those keys also need to be known somehow, but they are more readable than OCIDs and can have their naming standardized by DevOps, facilitating automation.

The *compartments_dependency* map is typically the output of another Terraform configuration that gets published in a well-defined location for easy consumption. For instance, [this example](./examples/external_dependency/README.md) uses OCI Object Storage object for sharing dependencies across Terraform configurations. 

The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting.

## <a name="related">Related Documentation</a>
- [OCI Cloud Guard](https://docs.oracle.com/en-us/iaas/cloud-guard/home.htm)
- [Cloud Guard in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_target)

## <a name="issues">Known Issues</a>
None.
