# Main Terraform Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {
  # Configuration options
}