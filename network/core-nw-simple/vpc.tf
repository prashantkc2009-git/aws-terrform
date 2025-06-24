// This Terraform file provisions the main AWS VPC.
// It sets the VPC CIDR block and enables DNS support and hostnames.
// The VPC is tagged with the environment and component for identification.

resource "aws_vpc" "my_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${local.environment}"
    Component = "aws_vpc"
  }
}