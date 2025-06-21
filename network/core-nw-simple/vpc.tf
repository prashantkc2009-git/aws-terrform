resource "aws_vpc" "my_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${local.environment}"
    Component = "aws_vpc"
  }
}