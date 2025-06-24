// INPUT:
//   - local.config.nat_gateways: List of NAT gateway definitions (each with name, enabled, subnet_name).
//   - aws_subnet.public: Map of public subnets, used to place NAT gateways.
//   - aws_internet_gateway.igw: Internet Gateway resource, required for NAT gateway creation.
//
// OUTPUT:
//   - Allocates Elastic IPs for each enabled NAT gateway.
//   - Creates AWS NAT gateways in specified public subnets, each tagged by name and associated with

ß
resource "aws_eip" "nat" {
  for_each = {
    for nat in local.config.nat_gateways : nat.name => nat
    if nat.enabled
  }
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  for_each = {
    for nat in local.config.nat_gateways : nat.name => nat
    if nat.enabled
  }
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.value.subnet_name].id

  tags = {
    Name = each.key
  }
  depends_on = [aws_internet_gateway.igw]
}