# OCI Landing Zones Vaults (a.k.a. KMS) Module

![Landing Zone logo](../landing_zone_300.png)

This module manages vaults and keys in Oracle Cloud Infrastructure (OCI) based on a single configuration object. OCI Vault is a key management service that stores and manages master encryption keys and secrets for secure access to resources.

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

This module requires the following OCI IAM permissions in the compartments where vaults and keys are defined. 

```
allow group <group> to manage vaults in compartment <vault-compartment-name>
allow group <group> to manage keys in compartment <key-compartment-name>
allow group <group> to manage policies in compartment <key-compartment-name>
allow group <group> to inspect compartments in tenancy
```

## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "vaults" {
  source = "../.."
  vaults_configuration = var.vaults_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the vaults module folder in this repository, as shown:
```
module "vaults" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security/vaults"
  vaults_configuration = var.vaults_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security//vaults?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

In this module, vaults and keys are defined using the *vaults_configuration* object, that supports the following attributes:
- **default_compartment_id**: the default compartment for all resources managed by this module. It can be overriden by *compartment_id* attribute in each resource. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **default_defined_tags**: the default defined tags that are applied to all resources managed by this module. It can be overriden by *defined_tags* attribute in each resource.
- **default_freeform_tags**: the default freeform tags that are applied to all resources managed by this module. It can be overriden by *freeform_tags* attribute in each resource.
- **vaults**: the vaults.
- **keys**: the encryption keys.
- **existing_keys_grants**: any existing keys to which grants should be assigned. 

### Defining Vaults

Within *vaults_configuration*, use the *vaults* attribute to define the vaults managed by this module. Each vault is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *vaults* attribute supports the following attributes:
- **name**: the vault name.
- **compartment_id**: the OCID of the compartment where the vault is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **type**: the vault type. Valid values are "DEFAULT" and "VIRTUAL_PRIVATE". Default is "DEFAULT", a regular virtual vault, in a shared HSM partition. For an isolated HSM partition, use "VIRTUAL_PRIVATE".
- **defined_tags**: the vault defined tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: the vault freeform tags. *default_freeform_tags* is used if undefined.

### Defining Keys

Within *vaults_configuration*, use the *keys* attribute to define the keys managed by this module. Each key is defined as an object whose index name must be unique and must not be changed once defined. As a convention, use uppercase strings for the index names.

The *keys* attribute supports the following attributes:
- **name**: the key name.
- **compartment_id**: the compartment where the key is created. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **vault_key**: the index name within the vaults attribute where this key belongs to.
- **vault_management_endpoint**: the vault management endpoint where this key belongs to. If provided, this value takes precedence over *vault_key*. **Use this attribute to add this key to a Vault that is managed elsewhere**. This attribute is overloaded. It can be assigned either a literal endpoint URL or a reference (a key) to an endpoint URL. See [External Dependencies](#ext_dep) for details.
- **algorithm**: the key algorithm. Valid values: "AES", "RSA", "ECDSA". Default: "AES".
- **length**: key length in bytes. "AES" lengths: 16, 24, 32. "RSA" lengths: 256, 384, 512. "ECDSA" lengths: 32, 48, 66. Default: 32.
- **curve_id**: curve id for "ECDSA" keys.
- **protection_mode**: indicates how the key is persisted and where crypto operations are performed. Valid values: "HSM" and "SOFTWARE". Default: "HSM". 
- **service_grantees**: the OCI service names allowed to use the key.
- **group_grantees**: the IAM group names allowed to use the key-delegate.
- **versions**: a list of strings representing key versions. Use this to rotate keys.
- **defined_tags**: the key defined_tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: the key freeform_tags. *default_freeform_tags* is used if undefined.
- **is_auto_rotation_enabled**: A parameter specifying whether the auto key rotation is enabled or not. Note that, currently the auto key rotation is only available when using "VIRTUAL_PRIVATE" vault.
- **last_rotation_message**: The last execution status message of auto key rotation.
- **last_rotation_status**: The status of last execution of auto key rotation.
- **rotation_interval_in_days**: The interval of auto key rotation. For auto key rotation the interval should between 60 day and 365 days (1 year). Note: User must specify this parameter when creating a new schedule.
- **time_of_last_rotation**: A property indicating last rotation date. Example: 2023-04-04T00:00:00Z.
- **time_of_next_rotation**: A property indicating next estimated scheduled time, as per the interval, expressed as date YYYY-MM-DD String. Example: 2023-04-04T00:00:00Z.
- **time_of_schedule_start**: A property indicating scheduled start date expressed as date YYYY-MM-DD String. Example: 2023-04-04T00:00:00Z.

### Defining Grants for Existing Keys

The module also allows for granting access to specified OCI services and IAM groups over **existing keys**. Such feature is enabled by *existing_keys_grants* attribute, that supports the following attributes:
- **key_id**: the existing key. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **compartment_id**: the existing key compartment. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID. See [External Dependencies](#ext_dep) for details.
- **service_grantees**: the OCI service names allowed to use the key.
- **group_grantees**: the IAM group names allowed to use the key-delegate.


## An Example

The following snippet defines a vault and two keys.
- The vault (*VISION-VAULT*) is created in a shared HSM partition (per module default value). 
- Both keys are AES 32-byte keys protected by HSM (per module default values). 
- The first key (*VISION-BUCKET-KEY*) is created in the *VISION-VAULT*, per *vault_key* value. It is created in the same compartment as the vault, as it does not assign *compartment_id*. It is granted access by Object Storage service in Ashburn region and by *vision-appdev-admin-group* IAM group. It has been rotated twice, per *versions* setting. 
- The second key (*VISION-BLOCK-VOLUME-KEY*) is created in an externally managed Vault identified by *vault_management_endpoint* URL. It is created in the same compartment as *VISION-VAULT* vault, as it does not assign *compartment_id*. It is granted access by Block Storage service and by *vision-appdev-admin-group* IAM group. It hasn't been rotated.

```
vaults_configuration = {
  default_compartment_id = "ocid1.compartment.oc1..aaaaaa...4ja"

  vaults = {
    VISION-VAULT = {
      name = "vision-vault"
    }
  }
  keys = {
    VISION-BUCKET-KEY = {
      name = "vision-buckey-key"
      vault_key = "VISION-VAULT"
      service_grantees = ["objectstorage-us-ashburn-1"]
      group_grantees = ["vision-appdev-admin-group"]
      versions = ["1","2"]
    }
    VISION-BLOCK-VOLUME-KEY = {
      name = "vision-block-volume-key"
      vault_management_endpoint = "https://dvs...lw...fe-management.kms.us-ashburn-1.oraclecloud.com"
      service_grantees = ["blockstorage"]
      group_grantees = ["vision-appdev-admin-group"]
    }
  }
} 
```

### <a name="ext_dep">External Dependencies</a>

The example above has some dependencies. Specifically, it requires *default_compartment_id* and *vault_management_endpoint*. These value needs to be obtained somehow. In some cases, you can simply get them from the teams that are managing those resources and operate on a manual copy-and-paste fashion. However, in the automation world, copying and pasting can be slow and error prone. More sophisticated automation approaches would get these dependencies from their producing Terraform configurations. With this scenario in mind, **the module overloads the attributes ending in *_id* and vault_management_endpoint attribute**. The *\*_id* attributes can be assigned a literal OCID (as in the example above, for those whom copying and pasting is an acceptable approach) or a reference (a key) to an OCID. The *vault_management_endpoint* attribute can be assigned a literal endpoint URL or a reference (a key) to an endpoint URL. If a reference is given, the module looks for compartments references in *compartments_dependency* and vaults references in *vaults_dependency* maps.

Rewriting the example above with the external dependency:

```
vaults_configuration = {
  default_compartment_id = "SECURITY-CMP"

  vaults = {
    VISION-VAULT = {
      name = "vision-vault"
    }
  }
  keys = {
    VISION-BUCKET-KEY = {
      name = "vision-buckey-key"
      vault_key = "VISION-VAULT"
      service_grantees = ["objectstorage-us-ashburn-1"]
      group_grantees = ["vision-appdev-admin-group"]
      versions = ["1","2"]
    }
    VISION-BLOCK-VOLUME-KEY = {
      name = "vision-block-volume-key"
      vault_management_endpoint = "SHARED-VIRTUAL-PRIVATE-VAULT"
      service_grantees = ["blockstorage"]
      group_grantees = ["vision-appdev-admin-group"]
    }
  }
} 

compartments_dependency = {
  "SECURITY-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...xuq"
  }
}

vaults_dependency = {
  "SHARED-VIRTUAL-PRIVATE-VAULT" : {
    "management_endpoint" : "https://dvs...lw...fe-management.kms.us-ashburn-1.oraclecloud.com"
  }
}
```

The example now relies on a reference to a compartment (*SECURITY-CMP* key) rather than a literal compartment OCID and on a reference to a management endpoint (*SHARED-VIRTUAL-PRIVATE-VAULT* key) rather than a literal endpoint URL. These keys also need to be known somehow, but they are more readable than OCIDs/URLs and can have their naming standardized by DevOps, facilitating automation.

The *compartments_dependency* and *vaults_dependency* maps are typically the output of other Terraform configurations that get published in a well-defined location for easy consumption. For instance, [this example](./examples/external_dependency/README.md) uses OCI Object Storage object for sharing dependencies across Terraform configurations. 

The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting.

## <a name="related">Related Documentation</a>
- [Overview of Vault](https://docs.oracle.com/en-us/iaas/Content/KeyManagement/Concepts/keyoverview.htm)
- [Vaults in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_vault)

## <a name="issues">Known Issues</a>
None.
