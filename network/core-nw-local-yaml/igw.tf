// INPUT:
//   - local.config.gateways.internet_gateway: Boolean flag to determine if an Internet Gateway should be created.
//   - aws_vpc.main.id: The ID of the main VPC to attach the Internet Gateway.
//
// OUTPUT:
//   - Creates an AWS Internet Gateway resource ("aws_internet_gateway.igw") and attaches it to the main VPC if enabled in the configuration.
//   - Tags the Internet Gateway with the name "main-igw".


resource "aws_internet_gateway" "igw" {
  count  = local.config.gateways.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}