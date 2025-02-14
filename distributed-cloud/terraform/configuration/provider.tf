# Main Terraform Provider

## Remove backend "remote" to run terraform state locally

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "f5xc-terraform-configuration-state"
    }
  }
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.33"
    }
  }
}

# Provider Options

provider "volterra" {
  api_p12_file = "../../../certs/wwt.api-creds.p12"
  url          = "https://wwt.console.ves.volterra.io/api"
}
