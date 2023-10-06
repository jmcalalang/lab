# Helm releases

# Argo
resource "helm_release" "argocd" {
  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.argo-chart-version
  depends_on = [
    kubectl_manifest.argo
  ]

  values = [
    "${file("./files/helm/argocd-values.yaml")}"
  ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

}

# BIG-IP Container Ingress Services
resource "helm_release" "cis" {
  name       = "cis"
  repository = "https://f5networks.github.io/charts/stable"
  chart      = "f5-bigip-ctlr"
  version    = var.big-ip-cis-chart-version

  values = [
    "${file("./files/helm/f5-bigip-ctlr-values.yaml")}"
  ]

  set {
    name  = "ingressClass.isDefaultIngressController"
    value = "false"
  }

  set {
    name  = "bigip_secret.create"
    value = "true"
  }

  set {
    name  = "bigip_secret.username"
    value = var.bigip_aks_username
  }

  set {
    name  = "bigip_secret.password"
    value = var.bigip_aks_password
  }

  set {
    name  = "version"
    value = var.big-ip-cis-image
  }

  set {
    name  = "args.bigip_partition"
    value = var.bigip_aks_partition
  }

  set {
    name  = "args.bigip_url"
    value = var.big-ip-ltm-management-address
  }

  set {
    name  = "args.insecure"
    value = "true"
  }

  set {
    name  = "args.custom-resource-mode"
    value = "true"
  }

  set {
    name  = "args.log-as3-response"
    value = "true"
  }

  set {
    name  = "args.gtm-bigip-username"
    value = var.bigip_aks_username
  }

  set {
    name  = "args.gtm-bigip-password"
    value = var.bigip_aks_password
  }

  set {
    name  = "args.gtm-bigip-url"
    value = var.big-ip-gtm-management-address
  }

  set {
    name  = "args.pool_member_type"
    value = "cluster"
  }

  set {
    name  = "args.log_level"
    value = "DEBUG"
  }

}

# NGINX plus ingress controller
resource "helm_release" "nginx-plus-ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "nginx-ingress"
  version    = var.nginx-ingress-controller-chart-version
  depends_on = [
    kubectl_manifest.nginx-ingress
  ]

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
    name  = "controller.ingressClass"
    value = "nginx"
  }

  set {
    name  = "controller.image.tag"
    value = var.nginx-ingress-controller-image
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
    name = "controller.globalConfiguration.spec"
    value = {
      "listeners" : [
        {
          "port" : "8888",
          "protocol" : "TCP",
          "name" : "tcp-listener",
        }
      ]
    }
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
resource "helm_release" "nginx-plus-ingressLink" {
  name       = "ingresslink"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "ingresslink"
  version    = var.nginx-ingress-controller-chart-version
  depends_on = [
    kubectl_manifest.nginx-ingresslink
  ]

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
    name  = "controller.ingressClass"
    value = "ingresslink-nginx"
  }

  set {
    name  = "controller.image.tag"
    value = var.nginx-ingress-controller-image
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

}
