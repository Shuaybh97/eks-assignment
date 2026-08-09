locals {
  charts = {
    traefik                              = "traefik"
    cert_manager                         = "cert-manager"
    external_dns                         = "external-dns"
    kube-prometheus-stack                = "kube-prometheus-stack"
    argocd                               = "argocd"
    secrets-store-csi-driver-provider-aws = "secrets-store-csi-driver-provider-aws"
  }
}
