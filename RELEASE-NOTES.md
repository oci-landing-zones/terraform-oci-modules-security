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
1. [VSS Module](#0-1-1-vss-updates)

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