data "aws_region" "current" {}

locals {
  global_tags = {
    ManagedBy   = "Terraform"
    Project     = "eks-assignment"
    Environment = var.environment
  }

  project_name = "eks-project"
  region       = var.region

  name_prefix = "${local.project_name}-${local.region}-${var.environment}"
}