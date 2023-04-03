# Kubernetes nginx unprivileged manifest

data "kubectl_path_documents" "nginx-unprivileged" {
  pattern = "./files/manifests/nginx-unprivileged/nginx-unprivileged-*.yaml"
  vars = {
    nginx-unprivileged-version = var.nginx-unprivileged-version
  }
}

resource "kubectl_manifest" "nginx-unprivileged" {
  for_each  = toset(data.kubectl_path_documents.nginx-unprivileged.documents)
  yaml_body = each.value
}