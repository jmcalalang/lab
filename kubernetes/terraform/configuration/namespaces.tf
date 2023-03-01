# Kubernetes namespaces

resource "kubernetes_namespace" "terraform" {
  metadata {
    name = "terraform"
  }
}