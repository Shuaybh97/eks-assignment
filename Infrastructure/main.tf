module "networking" {
  source      = "./terraform-modules/networking"
  vpc_cidr    = var.vpc_cidr
  global_tags = local.global_tags
}

module "eks_cluster_role" {
  source           = "./terraform-modules/iam"
  role_name        = "eks-project-cluster-role"
  service_name     = "eks.amazonaws.com"
  managed_policies = ["AmazonEKSClusterPolicy", "AmazonEKSVPCResourceController"]
  global_tags      = local.global_tags
}

module "eks_nodes_role" {
  source           = "./terraform-modules/iam"
  role_name        = "eks-project-nodes-role"
  service_name     = "ec2.amazonaws.com"
  managed_policies = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"]
  global_tags      = local.global_tags
}

module "eks" {
  source               = "./terraform-modules/eks"
  eks_cluster_name     = var.eks_cluster_name
  eks_cluster_role_arn = module.eks_cluster_role.role_arn
  node_group_role_arn  = module.eks_nodes_role.role_arn
  eks_cluster_version  = var.eks_cluster_version
  node_instance_type   = var.node_instance_type
  private_subnet_ids   = module.networking.private_subnet_ids
  global_tags          = local.global_tags
}

# module "irsa" {
#   source                        = "./modules/irsa"
#   depends_on                    = [module.eks]
#   cluster_name                  = var.eks_cluster_name
#   client_id_list                = var.client_id_list
#   cert_manager_role_name        = var.cert_manager_role_name
#   attach_cert_manager_policy    = var.attach_cert_manager_policy
#   cert_manager_hosted_zone_arns = var.cert_manager_hosted_zone_arns
#   cert_manager_namespace        = var.cert_manager_namespace
#   external_dns_role_name        = var.external_dns_role_name
#   attach_external_dns_policy    = var.attach_external_dns_policy
#   external_dns_hosted_zone_arns = var.external_dns_hosted_zone_arns
#   external_dns_namespace        = var.external_dns_namespace
#
# }


resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  depends_on = [module.eks]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [module.eks]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "upsert-only"
  }

  depends_on = [module.eks]
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.adminPassword"
    value = "admin"
  }

  depends_on = [module.eks]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  depends_on = [module.eks]
}

