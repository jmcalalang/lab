# Main Terraform Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
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
provider "tfe" {
  # Configuration options
}