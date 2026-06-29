module "networking" {
  source      = "../modules/networking"
  global_tags = local.global_tags
  vpc_config  = var.vpc_config
}

module "ecr" {
  source          = "../modules/ecr"
  repository_name = "${local.name_prefix}-ecr"
  global_tags     = local.global_tags
}

module "eks_cluster_role" {
  source           = "../modules/iam"
  role_name        = "${local.name_prefix}-cluster-role"
  service_name     = "eks.amazonaws.com"
  managed_policies = ["AmazonEKSClusterPolicy", "AmazonEKSVPCResourceController"]
  global_tags      = local.global_tags
}

module "eks_nodes_role" {
  source           = "../modules/iam"
  role_name        = "${local.name_prefix}-nodes-role"
  service_name     = "ec2.amazonaws.com"
  managed_policies = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"]
  global_tags      = local.global_tags
}

module "eks" {
  source                  = "../modules/eks"
  eks_cluster_name        = "${local.name_prefix}-cluster"
  eks_cluster_role_arn    = module.eks_cluster_role.role_arn
  node_group_role_arn     = module.eks_nodes_role.role_arn
  eks_cluster_version     = var.eks_cluster_version
  instance_types          = var.instance_types
  private_subnet_ids      = module.networking.private_subnet_ids
  vpc_id                  = module.networking.vpc_id
  vpc_cidr                = module.networking.vpc_cidr
  github_actions_role_arn = data.aws_iam_role.github_actions.arn
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = module.eks.oidc_issuer_url
  tags            = local.global_tags
}

module "portfolio_ecr_role" {
  source = "../modules/iam"

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
