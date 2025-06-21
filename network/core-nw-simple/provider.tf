terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      CreatedBy = "Terraform"
      Environment = "dev"
      Project = "core-network"
      Section = "network"
    }
  }
}