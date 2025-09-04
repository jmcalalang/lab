# Kubernetes argo application manifest resources

data "kubectl_path_documents" "argo" {
  pattern = "./files/manifests/app-*.yaml"
  vars = {
    app-gha-runner-scale-set-controller-version = var.app-gha-runner-scale-set-controller-version
  }
}

resource "kubectl_manifest" "argo" {
  for_each  = toset(data.kubectl_path_documents.argo.documents)
  yaml_body = each.value
}
