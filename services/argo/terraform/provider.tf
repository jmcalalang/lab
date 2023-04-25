# Main Terraform Provider

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "argo-terraform-configuration-state"
    }
  }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

# Provider Options

provider "kubectl" {
  # Configuration options
}
provider "kubernetes" {
  # Configuration options
}