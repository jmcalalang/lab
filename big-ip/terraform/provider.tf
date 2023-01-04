# Main Terraform Provider

terraform {
  required_providers {
    bigip = {
      source = "terraform-providers/bigip"
    }
  }
  required_version = ">= 0.13"
}

# BIG-IP Provider
# Set via GitHub Action Secrets

# provider "bigip" {
#   address  = var.hostname
#   username = var.username
#   password = var.password
# }