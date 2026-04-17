data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  tags = merge(var.global_tags, {
    module = "networking"
  })

  use_provided_public_cidrs  = length(var.vpc_config.public_subnet_cidrs) > 0
  use_provided_private_cidrs = length(var.vpc_config.private_subnet_cidrs) > 0

  public_subnet_count  = local.use_provided_public_cidrs ? length(var.vpc_config.public_subnet_cidrs) : var.vpc_config.public_subnet_count
  private_subnet_count = local.use_provided_private_cidrs ? length(var.vpc_config.private_subnet_cidrs) : var.vpc_config.private_subnet_count

  azs = slice(data.aws_availability_zones.available.names, 0, max(local.public_subnet_count, local.private_subnet_count))

  vpc_cidr_prefix        = tonumber(split("/", var.vpc_config.cidr_block)[1])
  public_subnet_newbits  = var.vpc_config.public_subnet_mask - local.vpc_cidr_prefix
  private_subnet_newbits = var.vpc_config.private_subnet_mask - local.vpc_cidr_prefix

  public_subnet_cidrs = local.use_provided_public_cidrs ? var.vpc_config.public_subnet_cidrs : [
    for i in range(local.public_subnet_count) :
    cidrsubnet(var.vpc_config.cidr_block, local.public_subnet_newbits, i + var.vpc_config.public_subnet_offset)
  ]

  private_subnet_cidrs = local.use_provided_private_cidrs ? var.vpc_config.private_subnet_cidrs : [
    for i in range(local.private_subnet_count) :
    cidrsubnet(var.vpc_config.cidr_block, local.private_subnet_newbits, i + var.vpc_config.private_subnet_offset)
  ]
}
