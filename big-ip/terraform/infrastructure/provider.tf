# Main Terraform Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
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
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "bigip" {
  # Configuration options
}
provider "tfe" {
  # Configuration options
}
provider "time" {
  # Configuration options
}
provider "random" {
  # Configuration options
}