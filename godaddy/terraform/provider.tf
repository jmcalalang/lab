# Main Terraform Provider

terraform {
  backend "remote" {
    organization = "jmcalalang-lab"
    hostname     = "app.terraform.io"
    workspaces {
      name = "godaddy-terraform-configuration-state"
    }
  }
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
      version = "1.9.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.44.1"
    }
  }
}

# Provider Options

provider "godaddy" {
  # Configuration options
}
provider "tfe" {
  # Configuration options
}