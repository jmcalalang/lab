# F5 AI Gateway manifest

data "kubectl_path_documents" "f5-ai-gateway" {
  pattern = "./files/manifests/f5-ai-gateway/f5-ai-gateway-*.yaml"
  vars = {
    namespace              = var.namespace
    f5_license_secret_jwt  = var.f5_license_secret_jwt
    f5_registry_secret_jwt = var.f5_registry_secret_jwt
  }
}

resource "kubectl_manifest" "f5-ai-gateway" {
  for_each  = toset(data.kubectl_path_documents.f5-ai-gateway.documents)
  yaml_body = each.value
  provider  = kubectl.kubectl-vk8s
}

# Kubernetes f5xc manifest resources

data "kubectl_path_documents" "f5xc" {
  pattern = "./files/manifests/f5xc/f5xc-*.yaml"
  vars = {
    f5xc_site_name  = "calalang-aks-site"
    f5xc_site_token = var.f5xc_site_token
  }
}

resource "kubernetes_manifest" "f5xc-namespace" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "ves-system"
    }
  }
  depends_on = [
    kubectl_manifest.nginx-ingress
  ]
}

resource "kubectl_manifest" "f5xc" {
  for_each  = toset(data.kubectl_path_documents.f5xc.documents)
  yaml_body = each.value
  depends_on = [
    kubernetes_manifest.f5xc-namespace
  ]
}

# Kubernetes argo manifest resources

data "kubectl_path_documents" "argo" {
  pattern = "./files/manifests/argo/argo-*.yaml"
  vars = {
  }
}

resource "kubernetes_manifest" "argo-namespace" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "argocd"
    }
  }
  depends_on = [
    kubectl_manifest.nginx-ingress
  ]
}

resource "kubectl_manifest" "argo" {
  for_each  = toset(data.kubectl_path_documents.argo.documents)
  yaml_body = each.value
  depends_on = [
    kubernetes_manifest.argo-namespace
  ]
}

# Kubernetes nginx ingress plus manifest

data "kubectl_path_documents" "nginx-ingress" {
  pattern = "./files/manifests/nginx-ingress/nginx-ingress-*.yaml"
  vars = {
    nginx_regcred_data       = var.nginx_regcred_data
    nginx_license_jwt_base64 = var.nginx_license_jwt_base64
  }
}

resource "kubectl_manifest" "nginx-ingress" {
  for_each  = toset(data.kubectl_path_documents.nginx-ingress.documents)
  yaml_body = each.value
}

# Kubernetes nginx ingresslink manifest

data "kubectl_path_documents" "nginx-ingresslink" {
  pattern = "./files/manifests/nginx-ingresslink/nginx-ingresslink-*.yaml"
  vars = {
    nginx_regcred_data       = var.nginx_regcred_data
    nginx_license_jwt_base64 = var.nginx_license_jwt_base64
  }
}

resource "kubectl_manifest" "nginx-ingresslink" {
  for_each  = toset(data.kubectl_path_documents.nginx-ingresslink.documents)
  yaml_body = each.value
}

# NGINX unprivileged manifest

data "kubectl_path_documents" "nginx-unprivileged" {
  pattern = "./files/manifests/nginx-unprivileged/nginx-unprivileged-*.yaml"
  vars = {
    nginx-unprivileged-version = var.nginx-unprivileged-version,
    namespace                  = var.namespace
  }
}

resource "kubectl_manifest" "nginx-unprivileged" {
  for_each  = toset(data.kubectl_path_documents.nginx-unprivileged.documents)
  yaml_body = each.value
  provider  = kubectl.kubectl-vk8s
}