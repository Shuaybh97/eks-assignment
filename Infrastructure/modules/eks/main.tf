resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "eks_nodes" {

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default"
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  instance_types = [var.instance_types]
}