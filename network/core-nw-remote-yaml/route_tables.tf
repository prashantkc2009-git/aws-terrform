// This Terraform file creates route tables and routes for the main AWS VPC based on remote configuration.
// It also associates public and private subnets with their respective route tables.

resource "aws_route_table" "this" {
  for_each = local.config.route_tables
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = each.key
  }
}

resource "aws_route" "this" {
  for_each = merge([
    for rt_name, rt in local.config.route_tables : {
      for route in rt.routes :
      "${rt_name}.${route.cidr_block}" => {
        rt_name    = rt_name
        cidr_block = route.cidr_block
        gateway    = route.gateway
      }
    }
  ]...)

  route_table_id         = aws_route_table.this[each.value.rt_name].id
  destination_cidr_block = each.value.cidr_block

  gateway_id = each.value.gateway == "igw" ? aws_internet_gateway.igw[0].id : null
  nat_gateway_id = contains(keys(aws_nat_gateway.nat), each.value.gateway) ? aws_nat_gateway.nat[each.value.gateway].id : null
}

resource "aws_route_table_association" "public" {
  for_each = {
    for subnet in local.config.public_subnets : subnet.name => subnet
  }
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for subnet in local.config.private_subnets : subnet.name => subnet
  }
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table].id
}