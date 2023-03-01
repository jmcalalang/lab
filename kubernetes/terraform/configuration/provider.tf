# Main Terraform Provider

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "~/.kube/config"
}

provider "kubectl" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}