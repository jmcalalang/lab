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
    #    aws = {
    #      source  = "hashicorp/aws"
    #      version = ">= 5.0.0"
    #    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.57.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

# Provider Options

# provider "aws" {
#   # Configuration options
#   region = "us-west-2"
# }
provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
provider "time" {
  # Configuration options
}
provider "random" {
  # Configuration options
}