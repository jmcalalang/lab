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
      version = "<= 0.11.26"
    }
  }
}

# Provider Options

provider "volterra" {
  api_p12_file = "../../../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}
