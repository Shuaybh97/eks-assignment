locals {
  tags = merge(var.global_tags, {
    module = "networking"
  })

  azs = slice(data.aws_availability_zones.zones, 0, 2)
}