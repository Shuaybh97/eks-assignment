resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

# Extend EKS-managed cluster security group for NLB traffic
resource "aws_security_group_rule" "allow_nlb_http" {
  type              = "ingress"
  description       = "Allow NLB to reach pods on NodePort range"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16", "77.99.247.116/32"]
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
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
