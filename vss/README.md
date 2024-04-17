# OCI Landing Zone Vulnerability Scanning Module

![Landing Zone logo](../landing_zone_300.png)

This module manages vulnerability scanning settings in Oracle Cloud Infrastructure (OCI) based on a single configuration object. OCI Vulnerability Scanning Service (VSS) helps improve a tenancy security posture by routinely checking hosts and container images for potential vulnerabilities.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for fully runnable examples.

- [Requirements](#requirements)
- [How to Invoke the Module](#invoke)
- [Module Functioning](#functioning)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>
### IAM Permissions

This module requires the following OCI IAM permissions in the compartments where VSS resources (recipes and targets) are managed.

```
allow group <group> to manage vss-family in compartment <vss-resources-compartment-name>
allow group <group> to use instances in compartment <vss-host-target-compartment-name>
allow group <group> to read repos in compartment <vss-container-target-compartment-name>
```

Additionally, VSS requires the following permissions:

```
allow service vulnerability-scanning-service to manage instances in tenancy
allow service vulnerability-scanning-service to read compartments in tenancy
allow service vulnerability-scanning-service to read repos in tenancy
allow service vulnerability-scanning-service to read vnics in tenancy
allow service vulnerability-scanning-service to read vnic-attachments in tenancy
```

### Scanning

Host scanning relies on Vulnerability Scanning cloud agent plugin enabled and running in target instances. After setting your host scanning targets using this module, make sure the plugin is available, enabled and running. In order to enable the plugin, the cloud agent needs an egress path to Oracle Services Network via a Service Gateway. Therefore, also make sure the subnet where the target instances are located have a route rule and security rule allowing such egress path. The [Landing Zone Compute module](https://github.com/oracle-quickstart/terraform-oci-secure-workloads/tree/main/cis-compute-storage) aids in enabling cloud agent plugins.

### Terraform Version < 1.3.x and Optional Object Type Attributes
This module relies on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which is experimental from Terraform 0.14.x to 1.2.x. It shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes. The feature has been promoted and it is no longer experimental in Terraform 1.3.x.

**As is, this module can only be used with Terraform versions up to 1.2.x**, because it can be consumed by other modules via [OCI Resource Manager service](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/home.htm), that still does not support Terraform 1.3.x.

Upon running *terraform plan* with Terraform versions prior to 1.3.x, Terraform displays the following warning:
```
Warning: Experimental feature "module_variable_optional_attrs" is active
```

Note the warning is harmless. The code has been tested with Terraform 1.3.x and the implementation is fully compatible.

If you really want to use Terraform 1.3.x, in [providers.tf](./providers.tf):
1. Change the terraform version requirement to:
```
required_version = ">= 1.3.0"
```
2. Remove the line:
```
experiments = [module_variable_optional_attrs]
```
## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "scanning" {
  source = "../.."
  scanning_configuration = var.scanning_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the VSS module folder in this repository, as shown:
```
module "scanning" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/vss"
  scanning_configuration = var.scanning_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security//vss?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

In this module, scanning recipes and targets are defined using the *scanning_configuration* object, that supports the following attributes:
- **default_compartment_id**: the default compartment for all resources managed by this module. It can be overriden by *compartment_id* attribute in each resource. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **default_defined_tags**: (Optional) the default defined tags that are applied to all resources managed by this module. It can be overriden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: (Optional) the default freeform tags that are applied to all resources managed by this module. It can be overriden by *freeform_tags* attribute in each resource.
- **host_recipes**: (Optional) the scanning recipes applicable to Compute instances.
- **host_targets**: (Optional) the scanning target Compute instances.
- **container_recipes**: (Optional) the scanning recipes applicable to container images.
- **container_targets**: (Optional) the scanning target container images. 

### Defining Host Recipes

Within *scanning_configuration*, use the *host_recipes* attribute to define the scanning recipes applicable to Compute instances. Each recipe is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *host_recipes* attribute supports the following attributes:
- **name**: the recipe name.
- **compartment_id**: (Optional) the compartment where the host recipe is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **port_scan_level**: (Optional) the port scan level. Valid values: "STANDARD", "LIGHT", "NONE". "STANDARD" checks the 1000 most common port numbers. "LIGHT" checks the 100 most common port numbers. "NONE" does not check for open ports. Default: "STANDARD".
- **schedule_settings**: (Optional) the schedule settings for host scans.
  - **type**: (Optional) how often the scan occurs. Valid values: "WEEKLY", "DAILY". Default: "WEEKLY".
  - **day_of_week**: (Optional) day of week the scan occurs. Only valid for "WEEKLY" scans. Default: "SUNDAY". 
- **agent_settings**: (Optional) agent scan settings
  - **scan_level**: (Optional) the agent scan level. Valid values: "STANDARD", "NONE". "STANDARD" enables agent-based scanning. "NONE" disables agent-based scanning. Default: "STANDARD".
  - **vendor**: (Optional) the vendor for host scan. Valid values: "OCI".
  - **cis_benchmark_scan_level**: (Optional) the scan level for CIS benchmark. Valid values: "STRICT", "MEDIUM", "LIGHTWEIGHT", "NONE". "STRICT": if more than 20% of the CIS benchmarks fail, then the target is assigned a risk level of Critical. "MEDIUM": if more than 40% of the CIS benchmarks fail, then the target is assigned a risk level of High. "LIGHTWEIGHT": if more than 80% of the CIS benchmarks fail, then the target is assigned a risk level of High. "NONE": disables CIS benchmark scanning. Default: "STRICT".
- **file_scan_settings**: (Optional) the file scan settings for host scans
  - **enable**: (Optional) whether file scans are enabled.
  - **scan_recurrence**: (Optional) scan recurrences in RFC-5545 section 3.3.10 format. Default: bi-weekly scans. Occurs on *schedule_settings*' *day_of_week* if *type* is "WEEKLY". Occurs on sundays if *schedule_settings*' *type* is "DAILY" ("FREQ=WEEKLY;INTERVAL=2;WKST=SU").
  - **folders_to_scan**: (Optional) a list of folders to scan. Default: "/".
  - **operating_system**: (Optional) the target operating system for the file scan. Valid values: "LINUX", "WINDOWS". Default: "LINUX".
- **defined_tags**: (Optional) the recipe defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the recipe freeform tags. *default_freeform_tags* is used if undefined.

### Defining Host Targets

Within *scanning_configuration*, use the *host_targets* attribute to define the Compute instances scanning targets. Each target is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *host_targets* attribute supports the following attributes:
- **name**: the target name.
- **description**: (Optional) the target description.
- **compartment_id**: (Optional) the compartment where the host target is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **target_compartment_id**: the target compartment containing the Compute instances to scan. All instances in the target compartment are scan targets. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **target_instance_ids**: (Optional) a list of target Compute instances to scan within *target_compartment_id*. If unset, all instances within *target_compartment_id* are scan targets. This attribute is overloaded. It can be assigned either literal OCIDs or references (keys) to OCIDs, mixed and matched. See [External Dependencies](#ext_dep) for details.
- **host_recipe_id**: the recipe id to use for the target. This can be a literal OCID or a referring key within *host_recipes*.
- **defined_tags**: (Optional) the host target defined_tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the host target freeform_tags. *default_freeform_tags* is used if undefined.

### Defining Container Recipes

Within *scanning_configuration*, use the *container_recipes* attribute to define the scanning recipes applicable to container images. Each recipe is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *container_recipes* attribute supports the following attributes:
- **name**: the recipe name.
- **compartment_id**: (Optional) the compartment where the container recipe is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **scan_level**: (Optional) the scan level. Default: "STANDARD".
- **image_count**: (Optional) the number of images to scan initially when the recipe is created. Default: 1.
- **defined_tags**: (Optional) the recipe defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the recipe freeform tags. *default_freeform_tags* is used if undefined.

### Defining Container Targets

Within *scanning_configuration*, use the *container_targets* attribute to define the container images scanning targets. Each target is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *container_targets* attribute supports the following attributes:
- **name**: the target name.
- **description**: (Optional) the target description.
- **compartment_id**: the compartment where the container target is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **target_registry**: the target image registry settings.
  - **compartment_id**: the registry target compartment for container images. All repositories in this compartment are scan targets. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
  - **type**: (Optional) the registry type. Default: "OCIR".
  - **repositories**: (Optional) a list of repositories to scan images. If undefined, the target defaults to scanning all repositories in the *compartment_id*.
  - **url**: (Optional) the URL of the registry. Required for non-OCI registry types (for OCI registry types, it is inferred from the tenancy).
- **container_recipe_id**: the recipe id to use for the target. This can be a literal OCID or a referring key within *container_recipes*.
- **defined_tags**: (Optional) the container target defined_tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the container target freeform_tags. *default_freeform_tags* is used if undefined.

## An Example

The following snippet defines a host recipe (*VISION-HOST-RECIPE*), a host target (*VISION-HOST-TARGET*), a container recipe (*VISION-CONTAINER-RECIPE*) and a container target (*VISION-CONTAINER-TARGET*), all created in the same compartment defined by *default_compartment_id*. The example uses module defaults and only defines the minimum required attributes. *VISION-HOST-RECIPE* recipe is used by *VISION-HOST-TARGET* target, while *VISION-CONTAINER-RECIPE* recipe is used by *VISION-CONTAINER-TARGET* target.

```
scanning_configuration = {
  default_compartment_id = "ocid1.compartment.oc1..aaaaaa...4ja"
  host_recipes = {
    VISION-HOST-RECIPE = {
      name = "vision-host-scan-recipe"
    }
  }

  host_targets = {
    VISION-HOST-TARGET = {
      name = "vision-host-scan-target"
      target_compartment_id = "ocid1.compartment.oc1..aaaaaa...kzq"
      host_recipe_id = "VISION-HOST-RECIPE" # this is a reference to the recipe defined in host_recipes attribute.
    }
  }

  container_recipes = {
    VISION-CONTAINER-RECIPE = {
      name = "vision-container-scan-recipe"
    }
  }

  container_targets = {
    VISION-CONTAINER-TARGET = {
      name = "vision-container-scan-target"
      target_registry = {
        compartment_id = "ocid1.compartment.oc1..aaaaaa...kzq"
      }
      container_recipe_id = "VISION-CONTAINER-RECIPE" # this is a reference to the recipe defined in container_recipes attribute.
    }
  }
}  
```

### <a name="ext_dep">External Dependencies</a>

The example above has some dependencies. Specifically, it requires *default_compartment_id*, *target_compartment_id* and *target_registry/compartment_id*. These values need to be obtained somehow. In some cases, you can simply get them from the teams that are managing those resources and operate on a manual copy-and-paste fashion. However, in the automation world, copying and pasting can be slow and error prone. More sophisticated automation approaches would get these dependencies from their producing Terraform configurations. With this scenario in mind, **the module overloads the attributes ending in *_id* and *_ids***. They can be assigned a literal OCID (as in the example above, for those whom copying and pasting is an acceptable approach) or a reference (a key) to an OCID.

Rewriting the example above with the external dependency:

```
scanning_configuration = {
  default_compartment_id = "SECURITY-CMP"
  host_recipes = {
    VISION-HOST-RECIPE = {
      name = "vision-host-scan-recipe"
    }
  }

  host_targets = {
    VISION-HOST-TARGET = {
      name = "vision-host-scan-target"
      target_compartment_id = "APPLICATION-CMP"
      host_recipe_id = "VISION-HOST-RECIPE" # this is a reference to the recipe defined in host_recipes attribute.
    }
  }

  container_recipes = {
    VISION-CONTAINER-RECIPE = {
      name = "vision-container-scan-recipe"
    }
  }

  container_targets = {
    VISION-CONTAINER-TARGET = {
      name = "vision-container-scan-target"
      target_registry = {
        compartment_id = "APPLICATION-CMP"
      }
      container_recipe_id = "VISION-CONTAINER-RECIPE" # this is a reference to the recipe defined in container_recipes attribute.
    }
  }
}  

compartments_dependency = {
  "SECURITY-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
  "APPLICATION-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...zrt"
  }
}

```

The example now relies on references to compartments (*SECURITY-CMP* and *APPLICATION-CMP* keys) rather than literal compartment OCIDs. These keys also need to be known somehow, but they are more readable than OCIDs and can have their naming standardized by DevOps, facilitating automation.

The *compartments_dependency* map is typically the output of another Terraform configuration that gets published in a well-defined location for easy consumption. For instance, [this example](./examples/external_dependency/README.md) uses OCI Object Storage object for sharing dependencies across Terraform configurations. 

The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting.

## <a name="related">Related Documentation</a>
- [Overview of Scanning](https://docs.oracle.com/en-us/iaas/scanning/using/overview.htm)
- [Scanning in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/vulnerability_scanning_host_scan_target)

## <a name="issues">Known Issues</a>
None.
