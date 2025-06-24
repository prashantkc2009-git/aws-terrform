// This Terraform file defines public and private route tables for the main AWS VPC.
// It associates subnets with the appropriate route tables and configures a public route for internet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-route-table"
    Component = "aws_route_table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private-route-table"
    Component = "aws_route_table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}