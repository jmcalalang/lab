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
provider "kubectl" {
  # Configuration options
  config_paths = [
    "/home/runner/work/lab/lab/distributed-cloud/terraform/configuration/kubeconfig.yaml"
  ]
  config_context   = "calalang-vk8s"
  load_config_file = false
}