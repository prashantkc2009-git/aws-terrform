## 🛠️ AWS Core Network Provisioning with Terraform & local YAML

- This repository contains a modular and flexible Terraform configuration for deploying foundational AWS network infrastructure. 
- It is designed to support multiple public/private subnets, route tables, Internet Gateways (IGW), NAT Gateways, and secondary CIDR blocks. 
- **This Terraform setup dynamically reads configuration from a YAML file (e.g., `core-network-ap-south-1.yaml`) and provisions the core network components in AWS based on its contents.**

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