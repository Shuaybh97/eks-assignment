locals {
  global_tags = {
    ManagedBy   = "Terraform"
    Project     = "eks-assignment"
    Environment = var.environment
  }

  project_name = "eks-project"
  name_prefix  = "${local.project_name}-${var.region}-${var.environment}"
}
