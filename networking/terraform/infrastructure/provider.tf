# Main Terraform Provider

## Remove backend "remote" to run terraform state locally

terraform {
  backend "remote" {
    organization = {}
    hostname     = {}
    token        = {}
    workspaces {
      name = "networking-terraform-infrastructure-state"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.57.0"
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