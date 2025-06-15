terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    yaml = {
      source  = "hashicorp/yaml"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = local.config["aws_region"]
}

data "local_file" "core_network" {
  filename = "${path.module}/core-network-ap-south-1.yaml"
}

locals {
  config = yamldecode(data.local_file.core_network.content)
}

# ---------------------- VPC ----------------------
resource "aws_vpc" "main" {
  cidr_block           = local.config["vpc"]["cidr_block"]
  enable_dns_hostnames = true

  tags = {
    Name = "core-vpc"
  }
}

# ------------------- Internet Gateway -------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "core-igw"
  }
}

# ------------------- Elastic IP for NAT -------------------
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "core-nat-eip"
  }
}

# ------------------- NAT Gateway -------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id # place NAT in first public subnet
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "core-nat-gw"
  }
}

# ---------------------- Public Subnets ----------------------
resource "aws_subnet" "public" {
  for_each = {
    for idx, subnet in local.config["public_subnets"] : idx => subnet
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# ---------------------- Private Subnets ----------------------
resource "aws_subnet" "private" {
  for_each = {
    for idx, subnet in local.config["private_subnets"] : idx => subnet
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]

  tags = {
    Name = "private-subnet-${each.key}"
  }
}

# ------------------- Public Route Table -------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "core-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ------------------- Private Route Table -------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "core-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}