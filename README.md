# OCI Landing Zone Security Modules

![Landing Zone logo](./landing_zone_300.png)

This repository contains Terraform OCI (Oracle Cloud Infrastructure) modules for security services that help customers align their OCI implementations with the CIS (Center for Internet Security) OCI Foundations Benchmark recommendations.

The following modules are available:
- [Bastion Service](./bastion/)
- [Cloud Guard](./cloud-guard/)
- [Security Zones](./security-zones/)
- [Vaults](./vaults/) (a.k.a KMS)
- [Vulnerability Scanning](./vss/)

Within each module you find an *examples* folder. Each example is a fully runnable Terraform configuration that you can quickly test and put to use by modifying the input data according to your own needs.  

## CIS OCI Foundations Benchmark Modules Collection

This repository is part of a broader collection of repositories containing modules that help customers align their OCI implementations with the CIS OCI Foundations Benchmark recommendations:
- [Identity & Access Management](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam)
- [Networking](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking)
- [Governance](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance)
- [Security](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security) - current repository
- [Observability & Monitoring](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability)
- [Secure Workloads](https://github.com/oracle-quickstart/terraform-oci-secure-workloads)

The modules in this collection are designed for flexibility, are straightforward to use, and enforce CIS OCI Foundations Benchmark recommendations when possible.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Help

Open an issue in this repository.

## Contributing

This project welcomes contributions from the community. Before submitting a pull request, please [review our contribution guide](./CONTRIBUTING.md).

## Security

Please consult the [security guide](./SECURITY.md) for our responsible security vulnerability disclosure process.

## License

Copyright (c) 2023,2024 Oracle and/or its affiliates.

*Replace this statement if your project is not licensed under the UPL*

Released under the Universal Permissive License v1.0 as shown at
<https://oss.oracle.com/licenses/upl/>.

## Known Issues
**1. Auto Key Rotation for Virtual Private Vaults in OC3 Does Not Work**

    Currently, Auto Key Rotation doesn't work in OC3 due to an issue with the Vault Service Data Lookup from the Terraform API. We're currently monitoring the issue for any updates.