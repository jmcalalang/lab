# Kubernetes manifest resource for deployments

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

# Kubernetes manifest resource for services

data "kubectl_path_documents" "services" {
  pattern = "./files/services/service-*.yaml"
  vars = {
    nginx_port = "80"
  }
}

resource "kubectl_manifest" "service_manifests" {
  depends_on = [
    kubernetes_namespace.terraform
  ]
  for_each  = toset(data.kubectl_path_documents.services.documents)
  yaml_body = each.value
}

# Kubernetes manifest resource for custom resource definitions