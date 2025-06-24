// This Terraform file provisions an Internet Gateway for the main AWS VPC
// and tags it for identification.

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main-igw"
    Component = "aws_internet_gateway"
  }
}