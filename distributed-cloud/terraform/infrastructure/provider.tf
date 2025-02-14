# Main Terraform Provider

## Remove backend "remote" to run terraform state locally

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "f5xc-terraform-infrastructure-state"
    }
  }
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.33"
    }
  }
}

# Provider Options

provider "random" {
  # Configuration options
}
provider "volterra" {
  api_p12_file = "../../../certs/wwt.api-creds.p12"
  url          = "https://wwt.console.ves.volterra.io/api"
}