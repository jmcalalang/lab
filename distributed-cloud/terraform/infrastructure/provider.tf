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
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87.0"
    }
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

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "random" {
  # Configuration options
}
provider "volterra" {
  api_p12_file = "../../../certs/wwt.api-creds.p12"
  url          = "https://wwt.console.ves.volterra.io/api"
}