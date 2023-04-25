## F5 Distributed Cloud Virtual Kubernetes Cluster

resource "volterra_virtual_k8s" "calalang-vk8s" {
  name      = var.vk8s-name
  namespace = var.namespace
  vsite_refs {
    namespace = var.namespace
    name      = "seattle"
  }
  vsite_refs {
    namespace = var.namespace
    name      = "singapore"
  }
  vsite_refs {
    namespace = var.namespace
    name      = "london"
  }
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
}