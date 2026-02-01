locals {
  tags = {
    Stack  = "irsa"
    Module = "iam-role-for-service-accounts"
  }

  cert_manager_service_accounts = [
    for sa in var.cert_manager_service_accounts :
    "system:serviceaccount:${sa}"
  ]

  external_dns_service_accounts = [
    for sa in var.external_dns_service_accounts :
    "system:serviceaccount:${sa}"
  ]
}
