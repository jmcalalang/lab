# Main Terraform Provider

terraform {
  backend "local" {
    path = "distributed-cloud/terraform.tfstate"
  }
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.19"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

# F5XC Provider

provider "volterra" {
  api_p12_file = "../../../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}
provider "kubernetes" {
  host                   = var.ves_vk8s_host
  config_context         = var.ves_vk8s_context
  client_certificate     = base64decode(var.ves_vk8s_client_certificate)
  client_key             = base64decode(var.ves_vk8s_client_key)
  cluster_ca_certificate = base64decode(var.ves_vk8s_cluster_ca_certificate)
  load_config_file       = false
}

provider "kubectl" {
  # Configuration options
}