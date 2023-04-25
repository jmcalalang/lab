# Main Terraform Provider

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "kubernetes-terraform-infrastructure-state"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

# Provider Options

provider "azurerm" {
  # Configuration options
  features {
  }
}
provider "random" {
  # Configuration options
}