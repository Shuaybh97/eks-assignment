resource "helm_release" "traefik" {
  name             = local.charts.traefik
  repository       = "https://traefik.github.io/charts"
  chart            = local.charts.traefik
  namespace        = local.charts.traefik
  create_namespace = true
  version          = "39.0.5"

  values = [
    templatefile("${path.module}/../../kubernetes/helm-values/${local.charts.traefik}.yaml", {
      public_subnets = join(",", data.terraform_remote_state.core.outputs.public_subnet_ids)
    })
  ]
}

resource "helm_release" "cert_manager" {
  name             = local.charts.cert_manager
  repository       = "https://charts.jetstack.io"
  chart            = local.charts.cert_manager
  namespace        = local.charts.cert_manager
  create_namespace = true
  version          = "v1.15.0"

  values = [
    file("${path.module}/../../kubernetes/helm-values/${local.charts.cert_manager}.yaml")
  ]
}

resource "helm_release" "external_dns" {
  name             = local.charts.external_dns
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = local.charts.external_dns
  namespace        = local.charts.external_dns
  create_namespace = true
  version          = "v1.21.1"

  values = [
    file("${path.module}/../../kubernetes/helm-values/${local.charts.external_dns}.yaml")
  ]
}

resource "helm_release" "argocd" {
  name             = local.charts.argocd
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = local.charts.argocd
  create_namespace = true
  version          = "v9.5.13"

  values = [
    file("${path.module}/../../kubernetes/helm-values/${local.charts.argocd}.yaml")
  ]
}

resource "helm_release" "kube_prometheus_stack" {
  name             = local.charts.kube-prometheus-stack
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = local.charts.kube-prometheus-stack
  namespace        = local.charts.kube-prometheus-stack
  create_namespace = true
  version          = "v85.0.3"
}
