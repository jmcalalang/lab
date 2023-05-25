# Main Terraform Provider

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "kubernetes-terraform-configuration-state"
    }
  }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
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
  host                   = var.ves_vk8s_server
  config_context         = var.ves_vk8s_context
  client_certificate     = base64decode(var.ves_vk8s_client_certificate)
  client_key             = base64decode(var.ves_vk8s_client_key)
  cluster_ca_certificate = base64decode(var.ves_vk8s_cluster_ca_certificate)
  load_config_file       = false
}
provider "kubernetes" {
  # Configuration options
}