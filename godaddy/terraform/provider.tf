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
  token = "63MKbIeOju4tvQ.atlasv1.E8ufk6QSMyjreA6AzPXimyEr3z10Vpaz01KSVasPQ5QU8y4C0PEgftmQJrJ6ShekN70"
}