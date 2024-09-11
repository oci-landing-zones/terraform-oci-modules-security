# CIS OCI Landing Zone Security Zones Module

![Landing Zone logo](../landing_zone_300.png)

This module manages security zones in Oracle Cloud Infrastructure (OCI) based on a single configuration object. OCI Security Zones let you be confident that OCI resources, including Compute, Networking, Object Storage, Block Volume and Database resources, comply with your security policies. Security zones are part of the [Cloud Guard](https://docs.oracle.com/en-us/iaas/cloud-guard/home.htm) family, but its controls are preventative.

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
module "security_zones" {
  source = "../.."
  security_zones_configuration = var.security_zones_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the Security Zones module folder in this repository, as shown:
```
module "security_zones" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/security_zones"
  security_zones_configuration = var.security_zones_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security//security_zones?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

In this module, Security Zones settings are defined using the *security_zones_configuration* object, that supports the following attributes:
- **default_cis_level**: the default CIS level setting for all recipes with an unspecified *cis_level* attribute. Valid values: "1" and "2". Default: "1". See [CIS Level Setting](#cis_level_setting) for details.
- **default_defined_tags**: the default defined tags that are applied to all resources managed by this module. It can be overriden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: the default freeform tags that are applied to all resources managed by this module. It can be overriden by *freeform_tags* attribute in each resource.
- **default_security_policies_ocids**: a list of default security zone policies OCIDs for all recipes with an unspecified *security_policies_ocids* attribute. These are merged with CIS security zone policies driven off *cis_level* attribute.
- **reporting_region**: the Cloud Guard reporting region, where all API calls, except reads, are made on. You can choose the reporting region among the available regions when enabling Cloud Guard. After Cloud Guard is enabled, you cannot change the reporting region without disabling and re-enabling Cloud Guard. Setting this attribute is required if Cloud Guard is enabled by this module. It defaults to tenancy home region if undefined.
- **self_manage_resources**: whether Oracle managed resources are created by customers. Default: false.
- **check_root_compartment**: Checks whether the user can deploy Security Zone resources in the root compartment. Default: true.
- **recipes**: the Security Zone recipes. A recipe is a set of policies.
- **security_zones**: the Security Zones. 

**Note**: The module enables the Cloud Guard service in the tenancy if Cloud Guard is not enabled. **It will not disable Cloud Guard under any circumstances**. For disabling Cloud Guard, use the OCI Console.

### Defining Recipes

Within *security_zones_configuration*, use the *recipes* attribute to define Security Zone recipes. Each recipe is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *recipes* attribute supports the following attributes:
- **name**: the recipe name.
- **description**: the recipe description. It defaults to *name* if undefined.
- **compartment_id**: the compartment where the Security Zone Recipe is created. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **cis_level**: the CIS level setting, driving the policies that are added to the recipe. Valid values: "1" and "2". Default: "1". See [CIS Level Setting](#cis_level_setting) for details.
- **security_policies_ocids**: a list of existing policis OCIDs that should be added to to the recipe. 
- **defined_tags**: the recipe defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: the recipe freeform tags. *default_freeform_tags* is used if undefined.

#### <a name="cis_level_setting">CIS Level Setting</a>

CIS level is a concept in the CIS Benchmark, determining the scope and strictness of security controls. Level 1 covers basic security settings, while level 2 extends level 1 and are intended for use cases where security is more critical than manageability and usability. From Security Zones perspective, they influence on the policies that are applied to Security Zones.

##### Level 1 Policies

- Deny public buckets (*deny public_buckets*)
- Deny public access to database instances (*deny db_instance_public_access*)

##### Level 2 Policies

- Level 1 policies +
- Deny Block Vulume without a customer managed key (*deny block_volume_without_vault_key*)
- Deny Book Volume without a customer managed key (*deny boot_volume_without_vault_key*) 
- Deny buckets without a customer managed key (*deny buckets_without_vault_key*)
- Deny file system without a customer managed key (*deny file_system_without_vault_key*)

### Defining Security Zones

Within *security_zones_configuration*, use the *security_zones* attribute to define the security zones. Each security zone is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *security_zones* attribute supports the following attributes:
- **name**: the security zone name.
- **description**: the security zone description. It defaults to *name* if undefined.
- **compartment_id**: the compartment where the Security Zone is created. Any existing Cloud Guard target for this compartment is replaced with the security zone. The security zone includes the default Oracle-managed configuration and activity detector recipes in Cloud Guard, and also scans resources in the zone for policy violations. The security zone applies to the compartment and all its sub-compartments. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **recipe_key**: the recipe index name in *recipes* attribute.
- **defined_tags**: the security zone defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: the security zone freeform tags. *default_freeform_tags* is used if undefined.

## An Example

The following snippet enables Cloud Guard service (if not already enabled), setting Ashburn as the reporting region, defining two recipes and one security zone. The recipes are stored in the same *compartment_ocid*. The first recipe (*CIS-L1-RECIPE*) is a CIS level 1 recipe (*cis_level = "1"*) while the second (*CIS-L2-RECIPE*) is a CIS level 2 recipe (*cis_level = "2"*). The security zone is defined for *compartment_ocid* and is associated with *CIS-l1-RECIPE*. *CIS-L2-RECIPE* is not associated with a security zone.

```
security_zones_configuration = {
  reporting_region = "us-ashburn-1" # It defaults to tenancy home region if undefined.
  
  recipes = {
    CIS-L1-RECIPE = {
      name = "vision-security-zone-cis-level-1-recipe"
      description = "CIS Level 1 recipe"
      compartment_id = "ocid1.compartment.oc1..aaaaaa...epa" 
      cis_level = "1"
    }
    CIS-L2-RECIPE = {
      name = "vision-security-zone-cis-level-2-recipe"
      description = "CIS Level 2 recipe"
      compartment_id = "ocid1.compartment.oc1..aaaaaa...epa"
      cis_level = "2"
    }
  }

  security_zones = {
    SECURITY-ZONE = {
      name = "vision-security-zone"
      compartment_id = "ocid1.compartment.oc1..aaaaaa...ufq"
      recipe_key = "CIS-L1-RECIPE"
    }  
  }
}
```
### <a name="ext_dep">External Dependencies</a>

The example above has some dependencies. Specifically, it requires *tenancy_ocid* and *compartment_id* values. These values need to be obtained somehow. In some cases, you can simply get them from the team that is managing compartments and operate on a manual copy-and-paste fashion. However, in the automation world, copying and pasting can be slow and error prone. More sophisticated automation approaches would get these dependencies from their producing Terraform configurations. With this scenario in mind, **the module overloads the attributes ending in *_id***. Note *tenancy_ocid* is immutable in the tenancy lifetime, hence the module expects that the literal tenancy OCID is used. The *\*_id* attributes can be assigned a literal OCID (as in the example above, for those whom copying and pasting is an acceptable approach) or a reference (a key) to an OCID. If a key to an OCID is given, the module requires a map of objects where the key and the OCID are expected to be found. This map of objects is passed to the module via the *compartments_dependency* attribute. 

Rewriting the example above with the external dependency:

```
security_zones_configuration = {
  reporting_region = "us-ashburn-1" # It defaults to tenancy home region if undefined.
  recipes = {
    CIS-L1-RECIPE = {
      name = "vision-security-zone-cis-level-1-recipe"
      description = "CIS Level 1 recipe"
      compartment_id = "CIS-LANDING-ZONE-CMP" 
      cis_level = "1"
    }
    CIS-L2-RECIPE = {
      name = "vision-security-zone-cis-level-2-recipe"
      description = "CIS Level 2 recipe"
      compartment_id = "CIS-LANDING-ZONE-CMP"
      cis_level = "2"
    }
  }

  security_zones = {
    SECURITY-ZONE = {
      name = "vision-security-zone"
      compartment_id = "CIS-LANDING-ZONE-CMP"
      recipe_key = "CIS-L1-RECIPE"
    }  
  }
}

compartments_dependency = {
  "CIS-LANDING-ZONE-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
}
```

The example now relies on a reference to a compartment (*CIS-LANDING-ZONE-CMP* key) rather than a literal compartment OCID. This key also need to be known somehow, but it is more readable than a OCID and can have its name standardized by DevOps, facilitating automation.

The *compartments_dependency* map is typically the output of another Terraform configuration that gets published in a well-defined location for easy consumption. For instance, [this example](./examples/external_dependency/README.md) uses OCI Object Storage object for sharing dependencies across Terraform configurations. 

The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting.

## <a name="related">Related Documentation</a>
- [OCI Security Zones](https://docs.oracle.com/en-us/iaas/security-zone/home.htm)
- [Security Zones in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/cloud_guard_security_zone)

## <a name="issues">Known Issues</a>
None.
