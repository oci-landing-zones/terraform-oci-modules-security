# Oracle Cloud Infrastructure (OCI) Terraform Bastion Module

![Landing Zone logo](../landing_zone_300.png)

This module manages bastions and bastion sessions in Oracle Cloud Infrastructure (OCI). OCI Bastion service provides restricted and time-limited access to target resources that do not have public endpoints. Bastions let authorized users connect from specific IP addresses to target resources using Secure Shell (SSH) sessions. When connected, users can interact with the target resource by using any software or protocol supported by SSH.

Teh module outputs the SSH command to run for any managed sessions.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for actual module usage.

- [Requirements](#requirements)
- [Module Functioning](#functioning)
  - [Bastions](#bastions)
  - [Sessions](#sessions)
  - [External Dependencies](#ext-dep)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>
### IAM Permissions

This module requires the following IAM permissions:
```
Allow group <GROUP-NAME> to manage bastion-family in compartment <BASTION-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to inspect work-requests in compartment <BASTION-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to read virtual-network-family in compartment <NETWORK-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to use subnets in compartment <NETWORK-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to use vnics in compartment <NETWORK-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to manage bastion-session in compartment <TARGET-INSTANCE-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to read instance-family in compartment <TARGET-INSTANCE-COMPARTMENT-NAME>
Allow group <GROUP-NAME> to read instance-agent-plugins in compartment <TARGET-INSTANCE-COMPARTMENT-NAME>
```

**Note:** the permissions account for a topology with multiple compartments, with distinct compartments for the bastion (\<BASTION-COMPARTMENT-NAME\>), the network (\<NETWORK-COMPARTMENT-NAME\>) and the bastion target instance (\<TARGET-INSTANCE-COMPARTMENT-NAME\>). In a simpler topology, those three compartments can be the same compartment.

For more information about Bastion policies [click here](https://docs.oracle.com/en-us/iaas/Content/Bastion/Tasks/managingbastions.htm).

### Terraform Version > 1.3.x
This module relies on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which has been promoted and no longer experimental in versions greater than 1.3.x. The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes.

## <a name="functioning">Module Functioning</a>
The module defines two top level attributes used to manage bastions and sessions: 
- **bastions_configuration**: for managing bastions.
- **sessions_configuration**: for managing bastion sessions.

### <a name="bastions">Bastions</a>
Bastions are managed using the **bastions_configuration** object. It contains a set of attributes starting with the prefix *default_* and one attribute named *bastions*. The *default_* attribute values are applied to all bastions within **bastions**, unless overridden at the bastion level.

The *default_* attributes are the following:
- **default_compartment_id**: Default compartment for all bastions. It can be overridden by *compartment_id* attribute in each bastion. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *compartments_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **default_defined_tags**: (Optional) Default defined tags for all bastions. It can be overridden by *defined_tags* attribute in each bastion.
- **default_freeform_tags**: (Optional) Default freeform tags for all bastions. It can be overridden by *freeform_tags* attribute in each bastion.
- **default_subnet_id**: (Optional) Default subnet for all bastions. It can be overridden by *subnet_id* attribute in each bastion. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *network_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **default_cidr_block_allow_list**: (Optional) Default CIDR blocks allowed to connect to bastions. It an be overridden by *cidr_block_allow_list* in each bastion.
- **enable_cidr_check**: (Optional) Whether provided CIDR blocks should be checked for "0.0.0.0\0". Default is true. When true, "0.0.0.0\0" is not allowed in *default_cidr_block_allow_list* and *cidr_block_allow_list*.

The bastions themselves are defined within the **bastions** attribute. In Terraform terms, it is a map of objects, where each object is referred by an identifying key. The supported attributes are listed below:
- **bastion_type**: (Optional) The bastion type. The only supported value is "STANDARD", which is the default value.
- **compartment_id**: (Optional) The bastion compartment. *default_compartment_id* is used if undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *compartments_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **subnet_id**: (Optional) The subnet ID where the bastion is created. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *network_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **defined_tags**: (Optional) Bastion defined_tags. *default_defined_tags* is used if undefined.
- **freeform_tags**: (Optional) Bastion freeform_tags. *default_freeform_tags* is used if undefined.
- **cidr_block_allow_list**: (Optional) The list of CIDR blocks allowed to connect to bastion.
- **enable_dns_proxy**: (Optional) Whether bastion support is enabled for FQDN and SOCKS5 proxy.
- **max_session_ttl_in_seconds**: (Optional) The maximum allowed time to live for bastion sessions.
- **name**: the bastion display name.

### <a name="sessions">Sessions</a>
Sessions are managed using the **sessions_configuration** object. It contains a set of attributes starting with the prefix *default_* and an attribute named *sessions* .The *default_* attribute values are applied to all sessions, unless overridden at the session object level.

The defined **default_** attributes are the following:
- **default_ssh_public_key**: (Optional) Default SSH public key path for all sessions. It can be overridden by the *ssh_public_key* attribute in each session.
- **default_session_type**: (Optional) Default session type for all sessions. Supported values are "MANAGED_SSH" and "PORT_FORWARDING". It can be overridden by *session_type* attribute in each session.

Sessions are defined using the  **sessions** attribute. In Terraform terms, it is a map of objects, where each object is referred by an identifying key. The following attributes are supported:
- **bastion_id**: The bastion where the session is created. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in the *bastions* map of objects.
- **ssh_public_key**: (Optional) The SSH public key path to connect to target. *default_ssh_public_key* is used if undefined.
- **session_type**: (Optional) The session type. Supported values are "MANAGED_SSH" and "PORT_FORWARDING". *default_session_type* if undefined.
- **target_resource**: Either the FQDN, OCID or IP of the target resource.
- **target_user**: (Optional) The SSH user name in the target resource. Required for "MANAGED_SSH" session type. 
- **target_port**: The SSH port number.
- **session_ttl_in_seconds**: (Optional) The session time to live.
- **session_name**: The session display name.

### <a name="ext-dep">External Dependencies</a>
An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:
- **compartments_dependency**: A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the compartment OCID.

Example:
```
{
	"APP-CMP": {
		"id": "ocid1.compartment.oc1..aaaaaaaa...7xq"
	}
}
```
- **network_dependency**: A map of objects containing the externally managed network resources (including subnets and network security groups) this module may depend on. All map objects must have the same type and should contain the following attributes:
  - An *id* attribute with the subnet OCID.
  - An *id* attribute with the network security group OCID.

Example:
```
{
  "subnets" : {
    "APP-SUBNET" : {
      "id" : "ocid1.subnet.oc1.iad.aaaaaaaax...e7a"
    }
  },
  "network_security_groups" : { 
    "APP-NSG" : {
      "id" : "ocid1.networksecuritygroup.oc1.iad.aaaaaaaa...xlq"
    }
  } 
}
```

- **instances_dependency**: A map of objects containing the externally managed compute resources this module may depend on. All map objects must have the same type and should contain the following attributes:
  - An *id* attribute with the instance OCID.

Example:
```
{
  "INSTANCE-1" : {
    "id" : "ocid1.instance.oc1.iad.aaaaaaaax...e7a"
  }, 
} 
```

- **clusters_dependency**: A map of objects containing the externally managed clusters resources this module may depend on. All map objects must have the same type and should contain the following attributes:
  - A *private_endpoint* attribute with endpoint IP.

Example:
```
{
  "OKE1" : {
    "endpoints" : {
        "private_endpoint" : "10.0.1.23"
    }
  }, 
} 
```
## <a name="related">Related Documentation</a>
- [Bastions](https://docs.oracle.com/en-us/iaas/Content/Bastion/Concepts/bastionoverview.htm)
- [Bastions in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_bastion)
- [Sessions](https://docs.oracle.com/en-us/iaas/Content/Bastion/Tasks/managingsessions.htm)
- [Bastion Sessions in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/bastion_session)

## <a name="issues">Known Issues</a>
None
