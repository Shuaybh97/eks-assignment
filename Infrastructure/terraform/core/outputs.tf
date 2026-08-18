output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS cluster API endpoint"
}

output "cluster_ca_certificate" {
  value       = module.eks.cluster_certificate_authority
  description = "EKS cluster CA certificate (base64 encoded)"
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
  description = "Public subnet IDs"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.eks_oidc.arn
  description = "ARN of the EKS OIDC provider"
}

output "ecr_repository_arn" {
  value       = module.ecr.repository_arn
  description = "ARN of the ECR repository"
}
