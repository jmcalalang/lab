# Kubernetes f5xc manifest resources

data "kubectl_path_documents" "f5xc" {
  pattern = "./files/manifests/f5xc/f5xc-*.yaml"
  vars = {
    f5xc_site_name  = "calalang-aks-site"
    f5xc_site_token = var.f5xc_site_token
  }
}

resource "kubectl_manifest" "f5xc" {
  for_each  = toset(data.kubectl_path_documents.f5xc.documents)
  yaml_body = each.value
}

# Kubernetes argo manifest resources

data "kubectl_path_documents" "argo" {
  pattern = "./files/manifests/argo/argo-*.yaml"
  vars = {
  }
}

resource "kubectl_manifest" "argo" {
  for_each  = toset(data.kubectl_path_documents.argo.documents)
  yaml_body = each.value
}

# Kubernetes nginx ingress plus manifest

data "kubectl_path_documents" "nginx-ingress" {
  pattern = "./files/manifests/nginx-ingress/nginx-ingress-*.yaml"
  vars = {
    nginx_repo_jwt = var.nginx_repo_jwt
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
    nginx_repo_jwt = var.nginx_repo_jwt
  }
}

resource "kubectl_manifest" "nginx-ingresslink" {
  for_each  = toset(data.kubectl_path_documents.nginx-ingresslink.documents)
  yaml_body = each.value
}