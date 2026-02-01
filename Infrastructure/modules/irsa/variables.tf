variable "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN associated with the EKS cluster"
  type        = string
}

variable "cert_manager_role_name" {
  description = "IAM role name for cert-manager IRSA"
  type        = string
}

variable "external_dns_role_name" {
  description = "IAM role name for external-dns IRSA"
  type        = string
}

variable "cert_manager_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs cert-manager can manage"
  type        = list(string)
}

variable "external_dns_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs external-dns can manage"
  type        = list(string)
}

variable "cert_manager_service_accounts" {
  description = "List of namespace:serviceaccount pairs for cert-manager"
  type        = list(string)
}

variable "external_dns_service_accounts" {
  description = "List of namespace:serviceaccount pairs for external-dns"
  type        = list(string)
}
