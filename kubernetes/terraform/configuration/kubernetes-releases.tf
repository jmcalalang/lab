# Kubernetes manifest resource for secret definitions

data "kubectl_path_documents" "secrets" {
  pattern = "./files/custom-resource-definitions/secret-*.yaml"
  vars = {
  }
}

resource "kubectl_manifest" "secret_manifests" {
  for_each  = toset(data.kubectl_path_documents.secrets.documents)
  yaml_body = each.value
}

# Kubernetes manifest resource for custom resource definitions

data "kubectl_path_documents" "crds" {
  pattern = "./files/custom-resource-definitions/crd-*.yaml"
  vars = {
  }
}

resource "kubectl_manifest" "crd_manifests" {
  for_each  = toset(data.kubectl_path_documents.crds.documents)
  yaml_body = each.value
}

# Kubernetes manifest resource for deployments

data "kubectl_path_documents" "deployments" {
  pattern = "./files/deployments/deployment-*.yaml"
  vars = {
  }
}

resource "kubectl_manifest" "deployment_manifests" {
  for_each  = toset(data.kubectl_path_documents.deployments.documents)
  yaml_body = each.value
}

# Kubernetes manifest resource for services

data "kubectl_path_documents" "services" {
  pattern = "./files/services/service-*.yaml"
  vars = {
  }
}

resource "kubectl_manifest" "service_manifests" {
  for_each  = toset(data.kubectl_path_documents.services.documents)
  yaml_body = each.value
}

# Kubernetes manifest resource for combined resources

data "kubectl_path_documents" "combined" {
  pattern = "./files/combined/combined-*.yaml"
  vars = {
    f5xc_site_name  = "calalang-aks-site"
    f5xc_site_token = var.f5xc_site_token
    nginx_repo_jwt  = var.nginx_repo_jwt
  }
}

resource "kubectl_manifest" "combined_manifests" {
  for_each  = toset(data.kubectl_path_documents.combined.documents)
  yaml_body = each.value
}