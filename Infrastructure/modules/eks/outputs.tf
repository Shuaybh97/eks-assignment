output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_issuer_url" {
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
  description = "OIDC issuer URL for the EKS cluster"
}

output "oidc_provider_url" {
  value       = replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  description = "OIDC provider URL without https:// prefix"
}

output "node_security_group_id" {
  value       = aws_security_group.eks_nodes_sg.id
  description = "Security group ID for EKS worker nodes"
}