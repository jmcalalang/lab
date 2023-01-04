# Main Terraform Provider

terraform {
  backend "local" {
    path = "godaddy/terraform.tfstate"
  }
  required_providers {
    godaddy = {
      source = "n3integration/godaddy"
    }
  }
}
