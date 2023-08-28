resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_chart_version

  values = [
    file("./template/values-ingress-nginx.yaml")
  ]
}


resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  name       = "cert-manager"
  namespace  = "cert-manager"
  version    = var.certmanager_chart_version

  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }
}

resource "time_sleep" "wait" {
  create_duration = "60s"

  depends_on = [helm_release.cert_manager]
}

resource "kubectl_manifest" "cluster_issuer" {
  count = var.cluster_issuer_create ? 1 : 0

  validate_schema = false

  yaml_body = var.cluster_issuer_yaml == null ? yamlencode(local.cluster_issuer) : var.cluster_issuer_yaml

  depends_on = [helm_release.cert_manager, time_sleep.wait]
}
