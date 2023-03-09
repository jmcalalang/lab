# Kubernetes manifest resources

data "kubectl_path_documents" "manifest" {
  pattern = "./files/manifests/manifest-*.yaml"
  vars = {
    f5xc_site_name  = "calalang-aks-site"
    f5xc_site_token = var.f5xc_site_token
    nginx_repo_jwt  = var.nginx_repo_jwt
  }
}

resource "kubectl_manifest" "manifests" {
  for_each  = toset(data.kubectl_path_documents.manifest.documents)
  yaml_body = each.value
}