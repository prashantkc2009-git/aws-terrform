// This Terraform file configures the AWS provider and specifies the required provider version.
// The AWS region is set using a local variable loaded from remote configuration.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}