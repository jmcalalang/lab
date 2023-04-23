# Main Terraform Provider

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
    }
  }
}

# Provider Options

provider "helm" {
  # Configuration options
}
provider "kubectl" {
  # Configuration options
}
provider "kubectl" {
  # Configuration options
  alias                  = "kubectl-vk8s"
  host                   = var.ves_vk8s_host
  config_context         = var.ves_vk8s_context
  client_certificate     = base64decode(var.ves_vk8s_client_certificate)
  client_key             = base64decode(var.ves_vk8s_client_key)
  cluster_ca_certificate = base64decode(var.ves_vk8s_cluster_ca_certificate)
  load_config_file       = false
}
provider "kubernetes" {
  # Configuration options
}
provider "tfe" {
  # Configuration options
}