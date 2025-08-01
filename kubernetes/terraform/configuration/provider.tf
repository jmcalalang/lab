# Main Terraform Provider

## Remove backend "remote" to run terraform state locally

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
      version = "2.17.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.38.0"
    }
  }
}

# Provider Options

provider "helm" {
  # Configuration options
}
provider "helm" {
  # Configuration options
  alias = "helm-vk8s"
  kubernetes {
    host                   = var.ves_vk8s_server
    client_certificate     = base64decode(var.ves_vk8s_client_certificate)
    client_key             = base64decode(var.ves_vk8s_client_key)
    cluster_ca_certificate = base64decode(var.ves_vk8s_cluster_ca_certificate)
  }
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