## AWS Network Infrastructure with Terraform

This repository contains a modular and flexible Terraform configuration for deploying foundational AWS network infrastructure. It is designed to support multiple public/private subnets, route tables, Internet Gateways (IGW), NAT Gateways, and secondary CIDR blocks.

### Remote Configuration via GitHub
This setup uses a remote YAML configuration file hosted in a GitHub repository to define the AWS network infrastructure. This approach allows centralized management of configuration across environments.

**Remote YAML Source**
```
data "http" "config_file" {
  url = "https://raw.githubusercontent.com/prashantkc2009-git/infra-config/main/terraform-aws/network/core-network-ap-south-1.yaml"
}
```
This downloads the YAML file containing the network specification.

## Directory Structure

```
network-infra/
    ├── core-network.yaml         # YAML config file to customize your network
    ├── main.tf                   # Terraform provider configuration
    ├── locals.tf                 # Local variables loaded from YAML
    ├── vpc.tf                    # VPC and secondary CIDR block definitions
    ├── igw.tf                    # Internet Gateway resource
    ├── nat.tf                    # NAT Gateways and Elastic IPs
    ├── subnet.tf                 # Public and private subnets
    ├── route_tables.tf           # Route tables, routes, and associations
    ├── README.md                 # This file
```

## Prerequisites

	•	Terraform >= 1.3
	•	AWS CLI configured (aws configure)
	•	Valid IAM permissions to create VPC resources

## YAML Configuration (`core-network-{region}.yaml`)

The `core-network.yaml` file defines the entire network structure and is the single source of truth for:

### Key Components:
- **aws_region**: AWS region where the resources will be deployed.
- **vpc**: Specifies the primary CIDR block and optional secondary CIDRs for the VPC.
- **gateways**: Enables or disables Internet Gateway.
- **nat_gateways**: Allows specifying one or more NAT Gateways with subnet placement.
- **route_tables**: Defines route tables with custom routes per subnet group.
- **public_subnets**: List of public subnets with CIDRs, AZs, and associated route table.
- **private_subnets**: List of private subnets with CIDRs, optional `extra_cidr_blocks`, AZs, and route table.

This file allows easy customization and scaling of the infrastructure without modifying Terraform code.

## How to Use
**Initialize Terraform**
terraform init

**Validate your configuration**
terraform validate

**Preview the infrastructure**
terraform plan

**Apply to deploy**
terraform apply


## Features
	•	✅ YAML-based configuration
	•	✅ Supports multiple public/private subnets
	•	✅ Conditional creation of Internet Gateway and NAT Gateways
	•	✅ Route tables with full control over routes
	•	✅ Support for secondary CIDR blocks
	•	✅ Easily extendable for future use

## Why Remote YAML?
	•	Centralized config for multiple environments (dev, staging, prod)
	•	Easy updates without modifying Terraform code
	•	Git version-controlled changes