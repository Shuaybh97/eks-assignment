locals {
  global_tags = {
    ManagedBy   = "Terraform"
    Project     = "eks-assignment"
    Environment = var.environment
  }

  project_name = "eks-project"
  name_prefix  = "${local.project_name}-${var.region}-${var.environment}"

  github_oidc_url = "token.actions.githubusercontent.com"

  github_oidc_provider_arn = var.create_github_oidc_provider ? aws_iam_openid_connect_provider.github_actions[0].arn : data.aws_iam_openid_connect_provider.github_actions[0].arn
}
