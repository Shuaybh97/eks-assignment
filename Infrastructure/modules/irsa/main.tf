terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "cert_manager_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.59.0"

  role_name                  = var.cert_manager_role_name
  attach_cert_manager_policy = true

  cert_manager_hosted_zone_arns = var.cert_manager_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = local.cert_manager_service_accounts
    }
  }

  tags = local.tags
}

module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.59.0"

  role_name                  = var.external_dns_role_name
  attach_external_dns_policy = true

  external_dns_hosted_zone_arns = var.external_dns_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = local.external_dns_service_accounts
    }
  }

  tags = local.tags
}
