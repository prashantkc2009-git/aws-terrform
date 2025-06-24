// This Terraform file defines public and private subnets for the main AWS VPC.
// It creates subnets using local variables for configuration, assigning each to the VPC.
// Public subnets are set to auto-assign public IPs on launch.
// Each subnet is tagged with its name, type, and component

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
    Type = "public"
    Component = "aws_subnet"
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
    Type = "private"
    Component = "aws_subnet"
  }
}