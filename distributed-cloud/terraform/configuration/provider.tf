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
  # Configuration options
  config_path = "$PWD/kubeconfig/config"
}
provider "kubectl" {
  # Configuration options
}