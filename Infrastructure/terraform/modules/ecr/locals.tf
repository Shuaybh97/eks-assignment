locals {
  tags = merge(var.global_tags, {
    module = "ecr"
  })
}
