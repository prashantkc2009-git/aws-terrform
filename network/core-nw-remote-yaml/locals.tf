data "http" "config_file" {
  url = "https://raw.githubusercontent.com/prashantkc2009-git/infra-config/main/terraform-aws/network/core-network-ap-south-1.yaml"
}

locals {
  config               = yamldecode(data.http.config_file.response_body)
  aws_region           = local.config.aws_region
  vpc_cidr             = local.config.vpc.cidr_block
  vpc_secondary_cidrs  = lookup(local.config.vpc, "secondary_cidr_blocks", [])

  all_cidrs_valid = alltrue([
    can(cidrhost(local.vpc_cidr, 0))
  ] ++ [
    for cidr in local.vpc_secondary_cidrs : can(cidrhost(cidr, 0))
  ])

  overlapping_cidrs = [
    for cidr in local.vpc_secondary_cidrs :
    cidr if cidrsubnet(cidr, 0, 0) == cidrsubnet(local.vpc_cidr, 0, 0)
  ]

  has_overlap = length(local.overlapping_cidrs) > 0
}