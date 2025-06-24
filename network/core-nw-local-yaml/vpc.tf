// INPUT: 
//   - local.vpc_cidr: The primary CIDR block for the main VPC (string).
//   - local.vpc_secondary_cidrs: A list or set of secondary CIDR blocks to associate with the VPC.
//
// OUTPUT:
//   - Creates an AWS VPC resource ("aws_vpc.main") with the specified primary CIDR block and a "Name" tag.
//   - Associates each secondary CIDR block from local.vpc_secondary_cidrs to the VPC using

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
