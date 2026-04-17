module "networking" {
  source      = "./modules/networking"
  global_tags = local.global_tags
  vpc_config  = var.vpc_config
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${local.name_prefix}-ecr"
  global_tags     = local.global_tags
}

module "eks_cluster_role" {
  source           = "./modules/iam"
  role_name        = "${local.name_prefix}-cluster-role"
  service_name     = "eks.amazonaws.com"
  managed_policies = ["AmazonEKSClusterPolicy", "AmazonEKSVPCResourceController"]
  global_tags      = local.global_tags
}

module "eks_nodes_role" {
  source           = "./modules/iam"
  role_name        = "${local.name_prefix}-nodes-role"
  service_name     = "ec2.amazonaws.com"
  managed_policies = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"]
  global_tags      = local.global_tags
}

module "eks" {
  source               = "./modules/eks"
  eks_cluster_name     = "${local.name_prefix}-cluster"
  eks_cluster_role_arn = module.eks_cluster_role.role_arn
  node_group_role_arn  = module.eks_nodes_role.role_arn
  eks_cluster_version  = var.eks_cluster_version
  instance_types       = var.instance_types
  private_subnet_ids   = module.networking.private_subnet_ids
  vpc_id               = module.networking.vpc_id
  load_balancer_sg_id  = module.networking.load_balancer_sg_id
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = module.eks.oidc_issuer_url
  tags            = local.global_tags
}

module "alb_controller_role" {
  source = "./modules/iam"

  role_name                  = "${local.name_prefix}-alb-controller-role"
  use_irsa                   = true
  oidc_provider_arn          = aws_iam_openid_connect_provider.eks_oidc.arn
  oidc_provider_url          = module.eks.oidc_provider_url
  kubernetes_namespace       = var.alb_controller_namespace
  kubernetes_service_account = var.alb_controller_service_account
  managed_policies           = []
  global_tags                = local.global_tags

  create_policy      = true
  policy_name        = "${local.name_prefix}-alb-controller-policy"
  policy_description = "IAM policy for AWS Load Balancer Controller"
  policy_statements = [
    {
      Effect = "Allow"
      Action = [
        "iam:CreateServiceLinkedRole",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInstances",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeTags",
        "ec2:GetCoipPoolUsage",
        "ec2:DescribeCoipPools",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "elasticloadbalancing:*",
        "cognito-idp:DescribeUserPoolClient",
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "iam:ListServerCertificates",
        "iam:GetServerCertificate",
      ]
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = [
        "ec2:CreateTags",
        "ec2:DeleteTags"
      ]
      Resource = ["arn:aws:ec2:*:*:security-group/*"]
    }
  ]
}

resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = var.traefik_namespace
  create_namespace = true
  version          = "39.0.5"

  values = [
    file("${path.module}/helm-values/traefik.yaml")
  ]

  depends_on = [
    module.eks
  ]
}
