# OCI Landing Zones Zero Trust Packet Routing (ZPR) Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Zero Trust Packet Routing in Oracle Cloud Infrastructure (OCI) based on a single configuration object. OCI ZPR enables organizations to set security attributes on resources and write natural language policies that limit network traffic based on the resources and data services accessed. 

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
This module requires the following OCI IAM permissions:
```
allow group <group> to manage zpr-configuration in tenancy
allow group <group> to manage zpr-policy in tenancy
allow group <group> to manage security-attribute-namespace in compartment <zpr-namespace-compartment-name>
```

## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "zpr" {
  source = "../../"
  tenancy_ocid = var.tenancy_ocid
  zpr_configuration = var.zpr_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the vaults module folder in this repository, as shown:
```
module "zpr" {
  source = "github.com/oci-landing-zones/terraform-oci-modules-security/zpr" 
  tenancy_ocid = var.tenancy_ocid
  zpr_configuration = var.zpr_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
source = "github.com/oci-landing-zones/terraform-oci-modules-security//zpr?ref=v0.1.9"
```

## <a name="functioning">Module Functioning</a>

In this module, ZPR settings are defined using the *zpr_configuration* object, that supports the following attributes:
- **default_defined_tags**: the default defined tags that are applied to all resources managed by this module. It can be overridden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: the default freeform tags that are applied to all resources managed by this module. It can be overridden by *freeform_tags* attribute in each resource.
- **namespaces**: the security attribute namespaces are containers for a set of security attributes.
- **security_attributes**: the security attributes are labels that can be referenced in ZPR policy to control access to supported resources.
- **zpr_policies**: the ZPR policies that enforce access control based on the security attributes that are applied to the resources involved in an access attempt. A policy is a container for a set of policy statements written in ZPL (ZPR Policy Language).

### Defining ZPR Namespaces

Within *zpr_configuration*, use the *namespaces* attribute to define the ZPR security attribute namespaces. Each namespace is defined as an object whose index name must be unique and must not be changed once defined.

The *namespaces* attribute supports the following attributes:

- **compartment_id**: The OCID of the tenancy where the namespace target is created. 
- **description**: the target description.
- **name**: the target name. The name must be unique across all namespaces in the tenancy and cannot be changed.
- **defined_tags**: (Optional) the namespace defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the namespace freeform tags. *default_freeform_tags* is used if undefined.


### Defining ZPR Security Attributes 

Within *zpr_configuration*, use the *security_attributes* attribute to define the ZPR security attributes. Each security attribute is defined as an object whose index name must be unique and must not be changed once defined.

The *security_attributes* attribute supports the following attributes:

- **description**: the target description.
- **name**: the target name. This is the security attribute key. The name must be unique within the namespace and cannot be changed.
- **namespace_id**: the OCID of the security attribute namespace.
- **namespace_name**: overloaded, either the key, name, or OCID of the security attribute namespace. If null or invalid, then the default *oracle-zpr* namespace will be used.
- **validator_type**: (Optional) Specifies the type of validation for a security attribute: set to *ENUM* if adding a validator, null otherwise.
- **validator_values**: (Optional) The list of allowed values for a security attribute value. Applicable when validator_type=ENUM. Each validator performs validation steps in addition to the standard validation for security attribute values. [More Information]("https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/security_attribute_security_attribute")
- **defined_tags**: (Optional) the security attribute defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the security attribute freeform tags. *default_freeform_tags* is used if undefined.


### Defining ZPR Policies

Within *zpr_configuration*, use the *zpr_policies* attribute to define the ZPR policies. Each policy is defined as an object whose index name must be unique and must not be changed once defined.

The *zpr_policies* attribute supports the following attributes:

- **description**: the target description.
- **name**: the target name. The name must be unique across all ZPL policies in the tenancy.
- **statements**: An array of ZprPolicy statements (up to 25 statements per ZprPolicy) written in the Zero Trust Packet Routing Policy Language. [More Information](https://docs.oracle.com/en-us/iaas/Content/zero-trust-packet-routing/managing-zpr-policies.htm#zpr-policy-template-builder)
- **defined_tags**: (Optional) the policy defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) the policy freeform tags. *default_freeform_tags* is used if undefined.



## An Example

The following snippet defines a Zero Trust Packet Routing (ZPR) Module with a namespace, 2 security attributes, and a ZPR policy with 1 statement. 

```
zpr_configuration = {
  default_defined_tags = null
  default_freeform_tags = null

  namespaces = {
    ZPR-VISION-NAMESPACE = {
      compartment_id = "ocid1.tenancy.oc1..aaaaaa...xuq"
      description = "Vision ZPR Security Attribute Namespace"
      name = "zpr-vision-namespace"
    }
  }

  security_attributes = {
    SECURITY-ATTRIBUTE-APP = {
      description = "Security attribute for zpr-vision-namespace applications"
      name = "app-security-attribute"
      namespace_key = "ZPR-VISION-NAMESPACE"
      validator_type = "ENUM"
      validator_values = ["hr-app", "payroll-app", "benefits-app"]
    }
    SECURITY-ATTRIBUTE-DEFAULT = {
      description = "Security attribute for default Oracle-ZPR namespace"
      name = "default-security-attribute"
      validator_type = "ENUM"
      validator_values = ["hr-app", "payroll-app", "benefits-app"]
    }
  }

  zpr_policies = {
    ZPR-POLICY-1 = {
      description = "ZPR policy"
      name = "zpr-policy-2"
      statements = [ "in default-security-attribute:hr-app VCN allow app-security-attribute:hr-app endpoints to connect to default-security-attribute:hr-app endpoints" ]
    }
  }
}
```
### <a name="ext_dep">External Dependencies</a>

The example above has some dependencies. Specifically, it requires *tenancy_ocid* and *resource_id* values. These values need to be obtained somehow. In some cases, you can simply get them from the team that is managing compartments and operate on a manual copy-and-paste fashion. However, in the automation world, copying and pasting can be slow and error-prone. More sophisticated automation approaches would get these dependencies from their producing Terraform configurations. With this scenario in mind, **the module overloads the attributes ending in *_id***. The *\*_id* attributes can be assigned a literal OCID (as in the example above, for those whom copying and pasting is an acceptable approach) or a reference (a key) to an OCID. If a key to an OCID is given, the module requires a map of objects where the key and the OCID are expected to be found. This map of objects is passed to the module via the *compartments_dependency* variable. 

Rewriting the example above with the external dependency:

```
zpr_configuration = {
  default_defined_tags = null
  default_freeform_tags = null

  namespaces = {
    ZPR-VISION-NAMESPACE = {
      compartment_id = "OCI-LANDING-ZONE-CMP"
      description = "Vision ZPR Security Attribute Namespace"
      name = "zpr-vision-namespace"
    }
  }

  security_attributes = {
    SECURITY-ATTRIBUTE-APP = {
      description = "Security attribute for zpr-vision-namespace applications"
      name = "app-security-attribute"
      namespace_key = "ZPR-VISION-NAMESPACE"
      validator_type = "ENUM"
      validator_values = ["hr-app", "payroll-app", "benefits-app"]
    }
    SECURITY-ATTRIBUTE-DEFAULT = {
      description = "Security attribute for default Oracle-ZPR namespace"
      name = "default-security-attribute"
      validator_type = "ENUM"
      validator_values = ["hr-app", "payroll-app", "benefits-app"]
    }
  }

  zpr_policies = {
    ZPR-POLICY-1 = {
      description = "ZPR policy"
      name = "zpr-policy-2"
      statements = [ "in default-security-attribute:hr-app VCN allow app-security-attribute:hr-app endpoints to connect to default-security-attribute:hr-app endpoints" ]
    }
  }
}

compartments_dependency = {
  "OCI-LANDING-ZONE-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
}
```

The example now relies on references to compartments (*OCI-LANDING-ZONE-CMP* key) rather than the literal compartment OCIDs. Those keys also need to be known somehow, but they are more readable than OCIDs and can have their naming standardized by DevOps, facilitating automation.

The *compartments_dependency* map is typically the output of another Terraform configuration that gets published in a well-defined location for easy consumption. For instance, [this example](./examples/external_dependency/README.md) uses OCI Object Storage object for sharing dependencies across Terraform configurations. 

The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting.

## <a name="related">Related Documentation</a>
- [Oracle ZPR Overview](https://docs.oracle.com/en-us/iaas/Content/zero-trust-packet-routing/home.htm)
- [ZPR in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/zpr_configuration)

## <a name="issues">Known Issues</a>
None.
