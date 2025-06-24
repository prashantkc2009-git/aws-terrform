// This Terraform file defines the core VPC resources for the AWS network.
// It creates the main VPC using a CIDR block from local variables and tags it appropriately.
// It also associates any secondary IPv4 CIDR blocks to the VPC using a for_each loop over a local variable.

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  for_each   = toset(local.vpc_secondary_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}
