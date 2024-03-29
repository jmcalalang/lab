# Main Terraform Provider

## Remove backend "remote" to run terraform state locally

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "godaddy-terraform-configuration-state"
    }
  }
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
      version = ">= 1.9.1"
    }
  }
}

# Provider Options

provider "godaddy" {
  # Configuration options
}