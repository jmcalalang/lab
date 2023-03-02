resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"

  values = [
    "${file("./files/helm/nginx-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd"
  chart      = "argo-cd"

  values = [
    "${file("./files/helm/argocd-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}