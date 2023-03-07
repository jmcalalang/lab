# Helm releases

resource "helm_release" "argocd" {
  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  values = [
    "${file("./files/helm/argocd-values.yaml")}"
  ]

  set {
    name      = "service.type"
    value     = "ClusterIP"
    namespace = "argocd"
  }

}