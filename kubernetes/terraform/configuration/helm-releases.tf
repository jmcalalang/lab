# Helm releases

# Argo
resource "helm_release" "argocd" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "5.24.1"

  values = [
    "${file("./files/helm/argocd-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}

# NGINX plus ingress controller
resource "helm_release" "nginx-plus-ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "nginx-ingress"
  version    = "0.16.2"

  values = [
    "${file("./files/helm/nginx-plus-ingress-values.yaml")}"
  ]

  set {
    name  = "controller.serviceAccount.imagePullSecretName"
    value = "regcred"
  }

  set {
    name  = "controller.nginxplus"
    value = "true"
  }

  set {
    name  = "controller.image.repository"
    value = "private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress"
  }

  set {
    name  = "controller.image.tag"
    value = "3.0.2"
  }

  set {
    name  = "controller.customConfigMap"
    value = "nginx-config"
  }

  set {
    name  = "controller.defaultTLS.secret"
    value = "nginx-ingress/default-server-secret"
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

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.globalConfiguration.create"
    value = "true"
  }

  set {
    name  = "controller.enableSnippets"
    value = "true"
  }

  set {
    name  = "controller.healthStatus"
    value = "true"
  }

}

# NGINX plus ingressLink controller
resource "helm_release" "nginx-plus-ingress" {
  name       = "ingresslink"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "ingresslink"
  version    = "0.16.2"

  values = [
    "${file("./files/helm/nginx-plus-ingress-values.yaml")}"
  ]

  set {
    name  = "controller.serviceAccount.imagePullSecretName"
    value = "regcred"
  }

  set {
    name  = "controller.nginxplus"
    value = "true"
  }

  set {
    name  = "controller.image.repository"
    value = "private-registry.nginx.com/nginx-ic-nap/nginx-plus-ingress"
  }

  set {
    name  = "controller.image.tag"
    value = "3.0.2"
  }

  set {
    name  = "controller.customConfigMap"
    value = "ingresslink-nginx-config"
  }

  set {
    name  = "controller.defaultTLS.secret"
    value = "ingresslink/default-server-secret"
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

  set {
    name  = "controller.replicaCount"
    value = "1"
  }

  set {
    name  = "controller.globalConfiguration.create"
    value = "true"
  }

  set {
    name  = "controller.enableSnippets"
    value = "true"
  }

  set {
    name  = "controller.healthStatus"
    value = "true"
  }

  set {
    name  = "controller.reportIngressStatus.ingressLink"
    value = "ingresslink-nginx-ingress"
  }

}