module "networking" {
  source      = "./modules/networking"
  vpc_cidr    = var.vpc_cidr
  global_tags = local.global_tags
}

module "eks_cluster_role" {
  source           = "./modules/iam"
  role_name        = "eks-project-cluster-role"
  service_name     = "eks.amazonaws.com"
  managed_policies = ["AmazonEKSClusterPolicy", "AmazonEKSVPCResourceController"]
  global_tags      = local.global_tags
}

module "eks_nodes_role" {
  source           = "./modules/iam"
  role_name        = "eks-project-nodes-role"
  service_name     = "ec2.amazonaws.com"
  managed_policies = ["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"]
  global_tags      = local.global_tags
}

module "eks" {
  source               = "./modules/eks"
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

# }

# module "helm" {
#   source                     = "./modules/helm"
#   depends_on_modules         = [module.irsa]
#   cert_manager_irsa_role_arn = module.irsa.cert_manager_irsa_role_arn
#   external_dns_irsa_role_arn = module.irsa.external_dns_irsa_role_arn
#   eks_cluster_name           = module.eks.eks_cluster_name
#   eks_cluster_endpoint       = module.eks.eks_cluster_endpoint
#   eks_cluster_ca_data        = module.eks.eks_cluster_certificate_authority
# }