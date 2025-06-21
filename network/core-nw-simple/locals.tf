locals {
  environment = "dev"
  region = "us-east-1"
 
  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnets = {
    public-subnet-1 = {
      cidr_block = "10.0.1.0/24"
      az         = local.azs[0]
    }
    public-subnet-2 = {
      cidr_block = "10.0.2.0/24"
      az         = local.azs[1]
    }
  }

  private_subnets = {
    private-subnet-1 = {
      cidr_block = "10.0.101.0/24"
      az         = local.azs[0]
    }
    private-subnet-2 = {
      cidr_block = "10.0.102.0/24"
      az         = local.azs[1]
    }
    private-subnet-3 = {
      cidr_block = "10.0.103.0/24"
      az         = local.azs[2]
    }
  }
}