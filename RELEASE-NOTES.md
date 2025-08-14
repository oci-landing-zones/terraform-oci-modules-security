# August 15, 2025 Release Notes - 0.2.2

## Updates
1. Formatted the code to adhere to Terraform standards.
2. Updated automatic key rotation configuration for virtual private vaults.

# June 12, 2025 Release Notes - 0.2.1

## Updates
1. Cloud-guard [README.md](./cloud-guard/README.md) updated to include required permissions for using cloud-guard in a stand alone case (without [OCI Core Landing Zone](https://github.com/oci-landing-zones/terraform-oci-core-landingzone)).
2. [Auto Key Rotation](./vaults/README.md) is available if your vault is a VPV (virtual private vault)


# January 23, 2025 Release Notes - 0.2.0

## Updates
1. By default [Cloud Guard module](./cloud-guard/) will not attempt to provision a target if a target already exists for the requested compartment. This is controlled by the attribute *ignore_existing_targets*, whose default value is *true*. Such an attempt would generate an error in Terraform, as only one user-defined target is allowed per compartment. The error can be let to occur by setting the attribute to *false*.


# November 01, 2024 Release Notes - 0.1.9

## New
1. [ZPR (Zero Trust Packet Routing)](./zpr/) module added.


# September 23, 2024 Release Notes - 0.1.8

## Updates
1. By default, [Security Zones](./security-zones/) cannot be created in the Root compartment. That is enforced in a Terraform precondition. For forcing a Security Zone in the Root compartment, set attribute *enable_opb_checks* to false.


# August 27, 2024 Release Notes - 0.1.7

## Updates
1. All modules now require Terraform binary equal or greater than 1.3.0.
2. *cislz-terraform-module* tag renamed to *ocilz-terraform-module*.


# July 19, 2024 Release Notes - 0.1.6

## Updates
1. Aligned [README.md](./README.md) structure to Oracle's GitHub organizations requirements.
2. [Bastion module](./bastion/)
    - In addition to an SSH public key path, an SSH public key literal string can now be used for defining Bastion sessions (*default_ssh_public_key* and *ssh_public_key* attributes).

# May 22, 2024 Release Notes - 0.1.5

## Updates
1. [Vaults module](./vaults/)
    - Virtual private vaults can now be configured for cross-region replication via the newly added *replica-region* attribute. Only applicable to virtual private vaults (VPVs).
2. [Security Zones module](./security-zones/)
    - *tenancy_ocid* attribute, once required in the *security_zones_configuration*, becomes a variable of its own.
    - *reporting_region* attribute of *security_zones_configuration* defaults to tenancy home region if not defined.

## Fixes
1. [VSS module](./vss/)
    - dynamic runtime dependency issue in *local.target_host_scan_cmps*. [Issue 541](https://orahub.oci.oraclecorp.com/nace-shared-services/cis-oci-landing-zone/-/issues/541).


# April 16, 2024 Release Notes - 0.1.4

## Updates
1. [Cloud Guard module](./cloud-guard/): ability to use "TENANCY-ROOT" key for referring to tenancy OCID in *cloud_guard_configuration*. *tenancy_ocid* becomes a variable of its own.
2. All modules: all dependency variables are now strongly typed, enhancing usage guidance.


# March 20, 2024 Release Notes - 0.1.3

## New
1. [Bastion module](./bastion/), with support for managed SSH and port forwarding sessions.

## Updates
1. Examples code in all modules updated with remote source references.
2. Examples documentation in all modules updated with remote link references.


# January 08, 2024 Release Notes - 0.1.2

## Updates
### All Modules
1. All modules now accept null value as the input variable assignment. This allows for easier automation of composed solutions.

## Updates
1. [VSS module](#0-1-1-vss-updates)

### <a name="0-1-1-vss-updates">VSS Module</a>
1. *image_count* attribute in *container_recipes* defaulted to 1.
2. Pre condition check added for container scan targets without an existing repository.
3. For host scan targets, the module outputs whether or not the Vulnerability Scanning cloud agent plugin is enabled for target instances.
4. *host_recipe_key* and *container_recipe_key* attributes renamed to *host_recipe_id* and *container_recipe_id*, respectively.
5. *host_recipe_id* can be assigned either a literal OCID or a referring key from *host_recipes*.
6. *container_recipe_id* can be assigned either a literal OCID or a referring key from *container_recipes*.


# July 03, 2023 Release Notes - 0.1.0

## New
1. [Initial Release](#0-1-0-initial)

### <a name="0-1-0-initial">Initial Release</a>
Modules for Cloud Guard, Security Zones, Vault (a.k.a KMS), and Vulnerability Scanning services.