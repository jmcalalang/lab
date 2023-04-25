# Main Terraform Provider

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
      version = "3.4.3"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.19"
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