// INPUT:
//   - core-network-us-east-1.yaml: YAML configuration file containing VPC and network settings.
//
// OUTPUT:
//   - Loads and decodes the YAML configuration into the 'config' local variable.
//   - Sets local variables for AWS region, VPC CIDR block, and secondary CIDR blocks based on the configuration


locals {
  config               = yamldecode(file("core-network-us-east-1.yaml"))
  aws_region           = local.config.aws_region
  vpc_cidr             = local.config.vpc.cidr_block
  vpc_secondary_cidrs  = lookup(local.config.vpc, "secondary_cidr_blocks", [])

}