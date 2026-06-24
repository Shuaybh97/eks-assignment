variable "environment" {
  type        = string
  description = "Environment name (e.g., sandbox, dev, prod)"
}

variable "region" {
  type        = string
  description = "AWS region for resource deployment"
}

variable "github_org" {
  type        = string
  description = "GitHub organisation or username that owns the repository"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name (without the org prefix)"
}

variable "create_github_oidc_provider" {
  type        = bool
  default     = true
  description = <<-EOT
    Whether to create the GitHub Actions OIDC provider in this AWS account.
    The provider is account-global, so set this to false if it already exists
    (e.g. created by another project in the same account).
  EOT
}
