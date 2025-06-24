locals {
  config               = yamldecode(file("core-network-us-east-1.yaml"))
  aws_region           = local.config.aws_region
  vpc_cidr             = local.config.vpc.cidr_block
  vpc_secondary_cidrs  = lookup(local.config.vpc, "secondary_cidr_blocks", [])

}