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
      version = ">= 0.11.22"
    }
  }
}

# Provider Options

provider "random" {
  # Configuration options
}
provider "volterra" {
  api_p12_file = "../../../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}