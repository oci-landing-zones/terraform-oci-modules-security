# Oracle Cloud Infrastructure (OCI) Terraform Bastion Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Bastions and Sessions in Oracle Cloud Infrastructure (OCI). These resources and their associated resources can be deployed together in the same configuration or separately. Additionally, the module supports bringing in external dependencies that managed resources depends on, including compartments, subnets and others. 

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

This module requires the following OCI IAM permissions:
For deploying Bastions:
```
Allow group <group-name> to manage bastion-family in compartment <compartment_name>
Allow group <group-name> to read virtual-network-family in compartment <compartment_name>
Allow group <group-name> to use vnics in compartment <compartment_name>
Allow group <group-name> to use subnets in compartment <compartment_name>
Allow group <group-name> to manage private-ips in compartment <compartment_name>
Allow group <group-name> to read instance-family in compartment <compartment_name>
Allow group <group-name> to read instance-agent-plugins in compartment <compartment_name>
Allow group <group-name> to inspect work-requests in compartment <compartment_name>
```
For more information about Bastion Policies [click here](https://docs.oracle.com/en-us/iaas/Content/Bastion/Tasks/managingbastions.htm).

### Terraform Version > 1.3.x
This module relies on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which has been promoted and no longer experimental in versions greater than 1.3.x. The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes.

## <a name="functioning">Module Functioning</a>
The module defines two top level attributes used to manage bastions and sessions: 
- **bastions_configuration** &ndash; for managing bastions.
- **sessions_configuration** &ndash; for managing sessions.

### <a name="bastions">BASTIONS</a>
Bastions are managed using the **bastions_configuration** object. It contains a set of attributes starting with the prefix **default_** and one attribute named **bastions**. The **default_** attribute values are applied to all bastions within **bastions**, unless overridden at the bastion level.

The *default_* attributes are the following:
- **default_compartment_id** &ndash; Default compartment for all bastions. It can be overriden by *compartment_id* attribute in each bastion. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *compartments_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **default_defined_tags** &ndash; (Optional) Default defined tags for all bastions. It can be overriden by *defined_tags* attribute in each bastion.
- **default_freeform_tags** &ndash; (Optional) Default freeform tags for all bastions. It can be overriden by *freeform_tags* attribute in each bastion.
- **default_subnet_id** &ndash; (Optional) Default for subnet for all bastions. It can be overriden by *subnet_id* attribute in each bastion. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *compartments_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **default_cidr_block_allow_list** &ndash; (Optional) Default for CIDR block allow list for all bastions. It an be overridden by *cidr_block_allow_list* in each bastion.

The bastions themselves are defined within the **bastions** attribute. In Terraform terms, it is a map of objects, where each object is referred by an identifying key. The supported attributes are listed below:
- **bastion_type** &ndash; (Optional) the bastion type. The supported attribute is "STANDARD".
- **compartment_id** &ndash; (Optional) the bastion compartment. *default_compartment_id* is used if it is undefined. This attribute is overloaded. It can be assigned either a literal OCID or a reference (a key) to an OCID in *compartments_dependency* variable. See [External Dependencies](#ext-dep) for details.
- **subnet_id** &ndash; (Optional) the subnet ID where the bastion will be created.
- **defined_tags** &ndash; (Optional) bastion defined_tags. default_defined_tags is used if this is not defined.
- **freeform_tags** &ndash; (Optional) bastion freeform_tags. default_freeform_tags is used if this is not defined.
- **cidr_block_allow_list** &ndash; (Optional) list of CIDR block that will be allowed to connect to bastion service.
- **enable_dns_proxy** &ndash; (Optional) boolean to enable FQDN and SOCKS5 Proxy Support on the bastion.
- **max_session_ttl_in_seconds** &ndash; (Optional) maximum allowed time to live for each session that will be created in the bastion.
- **name** &ndash; the bastion display name.

### <a name="sessions">Sessions</a>
Sessions are managed using the **sessions_configuration** object. It contains a set of attributes starting with the prefix **default_** and an attribute named **sessions** .The **default_** attribute values are applied to all sessions, unless overridden at the bastion unit level.
The defined **default_** attributes are the following:
- **default_ssh_public_key** &ndash; (Optional)default SSH public key path used to access the session. It can be overriden by the *ssh_public_key* attribute in each session.
- **default_session_type** &ndash; (Optional) default session type for all the sessions. It can be overridden by *session_type* attribute in each session.

#### <a name="sessions">Sessions</a>
Sessions are defined using the  **sessions** attribute. In Terraform terms, it is a map of objects, where each object is referred by an identifying key. The following attributes are supported:
- **bastion_id** &ndash; the OCID or the key of Bastion where the session will be created.
- **ssh_public_key** &ndash; (Optional) the ssh_public_key path used by the session to connect to target. The default_ssh_public_key is used if this is not defined.
- **ssh_private_key** &ndash; (Optional) the ssh_private_key path used by terraform to generate the command to connect to the target resource.
- **session_type** &ndash; (Optional) session type of the session. Supported values are MANAGED_SSH and PORT_FORWARDING. The default_session_type is used if this is not defined.
- **target_resource** &ndash; either the FQDN, OCID or IP of the target resource to connect the session to.
- **target_user** &ndash; (Optional) User of the target that will be used by session. It is required only with MANAGED_SSH. 
- **target_port** &ndash; port number that will be used by the session.
- **session_ttl_in_seconds** &ndash; (Optional) Session time to live.
- **session_name** &ndash; display name of session.

### <a name="ext-dep">External Dependencies</a>
An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:
- **compartments_dependency** &ndash; A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the compartment OCID.

Example:
```
{
	"APP-CMP": {
		"id": "ocid1.compartment.oc1..aaaaaaaa...7xq"
	}
}
```
- **network_dependency** &ndash; A map of objects containing the externally managed network resources (including subnets and network security groups) this module may depend on. All map objects must have the same type and should contain the following attributes:
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

- **instances_dependency** &ndash; A map of objects containing the externally managed compute resources this module may depend on. All map objects must have the same type and should contain the following attributes:
  - An *id* attribute with the instance OCID.

Example:
```
{
  "INSTANCE-1" : {
    "id" : "ocid1.instance.oc1.iad.aaaaaaaax...e7a"
  }, 
} 
```
- **clusters_dependency** &ndash; A map of objects containing the externally managed clusters resources this module may depend on. All map objects must have the same type and should contain the following attributes:
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

## <a name="related">Related Documentation</a>
- [Bastions](https://docs.oracle.com/en-us/iaas/Content/Bastion/Concepts/bastionoverview.htm)
- [Sessions](https://docs.oracle.com/en-us/iaas/Content/Bastion/Tasks/managingsessions.htm)



## <a name="issues">Known Issues</a>
None
