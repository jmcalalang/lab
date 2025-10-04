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
  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    },
    {
      name  = "server.insecure"
      value = "true"
    }
  ]
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
  set = [
    {
      name  = "ingressClass.isDefaultIngressController"
      value = "false"
    },
    {
      name  = "bigip_secret.create"
      value = "true"
    },
    {
      name  = "bigip_secret.username"
      value = var.bigip_aks_username
    },
    {
      name  = "bigip_secret.password"
      value = var.bigip_aks_password
    },
    {
      name  = "version"
      value = var.big-ip-cis-image
    },
    {
      name  = "args.bigip_partition"
      value = var.bigip_aks_partition
    },
    {
      name  = "args.bigip_url"
      value = var.big-ip-ltm-management-address
    },
    {
      name  = "args.insecure"
      value = "true"
    },
    {
      name  = "args.custom-resource-mode"
      value = "true"
    },
    {
      name  = "args.log-as3-response"
      value = "true"
    },
    {
      name  = "args.gtm-bigip-username"
      value = var.bigip_aks_username
    },
    {
      name  = "args.gtm-bigip-password"
      value = var.bigip_aks_password
    },
    {
      name  = "args.gtm-bigip-url"
      value = var.big-ip-gtm-management-address
    },
    {
      name  = "args.pool_member_type"
      value = "cluster"
    },
    {
      name  = "args.log_level"
      value = "DEBUG"
    }
  ]
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
    "${file("./files/helm/nginx-plus-ingress-values.yaml")}",
    "${file("./files/helm/nginx-ingress-custom-values.yaml")}"
  ]
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
    "${file("./files/helm/nginx-plus-ingress-values.yaml")}",
    "${file("./files/helm/nginx-ingresslink-custom-values.yaml")}"
  ]
}
