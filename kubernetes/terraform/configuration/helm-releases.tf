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