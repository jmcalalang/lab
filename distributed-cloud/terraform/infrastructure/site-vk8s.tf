resource "volterra_virtual_k8s" "calalang-vk8s" {
  name      = var.vk8s-name
  namespace = var.namespace
  vsite_refs {
    tenant    = "ves-io"
    namespace = "shared"
    name      = "ves-io-all-res"
  }
  labels = {
    "owner" = var.owner
  }
}