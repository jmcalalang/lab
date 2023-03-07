# Helm releases

resource "helm_release" "argocd" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    "${file("./files/helm/argocd-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}

resource "helm_release" "nginx-plus-ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "nginx-ingress"

  values = [
    "${file("./files/helm/nginx-plus-ingress-values.yaml")}"
  ]

  set {
    name  = "controller.serviceAccount.imagePullSecretName"
    value = "regcred"
  }

  set {
    name  = "controller.appprotect.enable"
    value = "true"
  }

  set {
    name  = "controller.enableOIDC"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }

}