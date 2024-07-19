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