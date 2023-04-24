# Main Terraform Provider

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "big-ip-terraform-configuration-state"
    }
  }
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.2"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
    }
  }
}

# Provider Options

provider "bigip" {
  # Configuration options
  # Set as Environment Variables
}
provider "tfe" {
  # Configuration options
}