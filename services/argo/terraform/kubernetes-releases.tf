# Kubernetes argo application manifest resources

data "kubectl_path_documents" "argo" {
  pattern = "./files/manifests/app-*.yaml"
  vars = {
    app_gha_runner_version = var.app_gha_runner_version
    gha_runner_github_token = var.gha_runner_github_token
  }
}

resource "kubectl_manifest" "argo" {
  for_each  = toset(data.kubectl_path_documents.argo.documents)
  yaml_body = each.value
}
