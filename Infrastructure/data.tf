data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_iam_role" "github_actions" {
  name = "github-actions-oidc-${var.environment}"
}