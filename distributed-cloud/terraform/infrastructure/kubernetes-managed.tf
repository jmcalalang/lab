## F5 Distributed Cloud Managed Kubernetes Cluster

resource "volterra_k8s_cluster" "f5xc-managed-kubernetes" {
  name                 = var.mk8s-name
  namespace            = "system"
  global_access_enable = true
  local_access_config {
    local_domain = var.mk8s-domain
  }
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
}