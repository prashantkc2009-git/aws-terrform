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