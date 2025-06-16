resource "aws_internet_gateway" "igw" {
  count  = local.config.gateways.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}