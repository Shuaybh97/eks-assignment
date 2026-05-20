locals {
  charts = {
    traefik = "traefik"
    cert_manager = "cert-manager"
    external_dns = "external-dns"
    kube-prometheus-stack = "kube-prometheus-stack"
    argocd = "argocd"
  }
}

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
  vpc_cidr             = module.networking.vpc_cidr
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = module.eks.oidc_issuer_url
  tags            = local.global_tags
}

resource "helm_release" "traefik" {
  name             = local.charts.traefik
  repository       = "https://traefik.github.io/charts"
  chart            = local.charts.traefik
  namespace        = local.charts.traefik
  create_namespace = true
  version          = "39.0.5"

  values = [
    templatefile("${path.module}/helm-values/${local.charts.traefik}.yaml", {
      public_subnets = join(",", module.networking.public_subnet_ids)
    })
  ]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "cert_manager" {
  name             = local.charts.cert_manager
  repository       = "https://charts.jetstack.io"
  chart            =  local.charts.cert_manager
  namespace        = local.charts.cert_manager
  create_namespace = true
  version          = "v1.15.0"

  values = [
    file("${path.module}/helm-values/${local.charts.cert_manager}.yaml")
  ]

  depends_on = [
    module.eks
  ]
}



resource "helm_release" "external_dns" {
  name             = local.charts.external_dns
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = local.charts.external_dns
  namespace        = local.charts.external_dns
  create_namespace = true
  version          = "v1.21.1"

  values = [
    file("${path.module}/helm-values/${local.charts.external_dns}.yaml")
  ]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "argocd" {
  name             = local.charts.argocd
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = local.charts.argocd
  create_namespace = true
  version          = "v9.5.13"

  values = [
    file("${path.module}/helm-values/${local.charts.argocd}.yaml")
  ]

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "kube-prometheus-stack" {
  name             = local.charts.kube-prometheus-stack
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = local.charts.kube-prometheus-stack
  namespace        = local.charts.kube-prometheus-stack
  create_namespace = true
  version          = "v85.0.3"

  depends_on = [
    module.eks
  ]
}



