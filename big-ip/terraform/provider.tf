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
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.1"
    }
  }
}

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

provider "time" {
  # Configuration options
}

provider "bigip" {
  # Configuration options
  
  # Set as Environment Variables
  # BIGIP_HOST
  # BIGIP_USER
  # BIGIP_PASSWORD
}