# Main Terraform Provider

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "big-ip-terraform-infrastructure-state"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.1"
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

provider "aws" {
  # Configuration options
  region = "us-west-2"
}
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
provider "time" {
  # Configuration options
}
provider "random" {
  # Configuration options
}