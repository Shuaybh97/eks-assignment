# IRSA for Portfolio App ECR Access
module "portfolio_ecr_role" {
  source = "./modules/iam"

  role_name                  = "${local.name_prefix}-portfolio-ecr-role"
  use_irsa                   = true
  oidc_provider_arn          = aws_iam_openid_connect_provider.eks_oidc.arn
  oidc_provider_url          = module.eks.oidc_provider_url
  kubernetes_namespace       = "default"
  kubernetes_service_account = "portfolio-sa"
  managed_policies           = []
  global_tags                = local.global_tags

  create_policy      = true
  policy_name        = "${local.name_prefix}-portfolio-ecr-policy"
  policy_description = "IAM policy for Portfolio app to pull images from ECR"
  policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
      Resource = [module.ecr.repository_arn]
    },
    {
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken"
      ]
      Resource = ["*"]
    }
  ]
}
