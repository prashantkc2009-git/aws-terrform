resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  lifecycle {
    precondition {
      condition     = local.all_cidrs_valid
      error_message = "One or more CIDR blocks are invalid."
    }
    precondition {
      condition     = !local.has_overlap
      error_message = "Secondary CIDR block overlaps with primary."
    }
  }

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  for_each   = toset(local.vpc_secondary_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}
