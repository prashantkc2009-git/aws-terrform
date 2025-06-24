// INPUT:
//   - local.config.public_subnets: List of objects defining public subnets (each with name, cidr_block, availability_zone).
//   - local.config.private_subnets: List of objects defining private subnets (each with name, cidr_block, availability_zone).
//   - aws_vpc.main.id: The ID of the main VPC to associate subnets with.
//
// OUTPUT:
//   - Creates public subnets in the main VPC, each with auto-assign public IP enabled and tagged by name.
//   - Creates private subnets in the main VPC, each

resource "aws_subnet" "public" {
  for_each = { for subnet in local.config.public_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private" {
  for_each = { for subnet in local.config.private_subnets : subnet.name => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}
