resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true
  version    = "68.1.0"

  set {
    name  = "grafana.adminPassword"
    value = "admin123" # Change this in production!
  }

  set {
    name  = "grafana.service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "loki_stack" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "monitoring"
  create_namespace = true
  version    = "2.10.2"

  set {
    name  = "promtail.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.enabled"
    value = "true"
  }

  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "sre-portal-dashboard"
    namespace = "monitoring"
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "sre-portal.json" = file("${path.module}/dashboards/sre-portal.json")
  }

  depends_on = [helm_release.kube_prometheus_stack]
}
