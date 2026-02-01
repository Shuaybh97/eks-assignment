output "cert_manager_irsa_role_arn" {
  description = "IAM role ARN used by cert-manager via IRSA"
  value       = module.cert_manager_irsa.iam_role_arn
}

output "external_dns_irsa_role_arn" {
  description = "IAM role ARN used by external-dns via IRSA"
  value       = module.external_dns_irsa.iam_role_arn
}
