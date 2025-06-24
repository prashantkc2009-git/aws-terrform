// This Terraform file configures the AWS provider and sets default tags for all resources.
// It specifies the required provider version and uses a local variable for

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