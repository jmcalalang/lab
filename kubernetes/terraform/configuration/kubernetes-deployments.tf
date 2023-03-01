# Kubernetes manifest resource for NGINX

data "kubectl_path_documents" "deployments" {
  pattern = "./files/deployments/deployment-*.yaml"
  vars = {
    nginx_image = "nginx:1.14.2"
  }
}

resource "kubectl_manifest" "deployment_manifests" {
  depends_on = [
    kubernetes_namespace.terraform
  ]
  for_each  = toset(data.kubectl_path_documents.deployments.documents)
  yaml_body = each.value
}