# Main Terraform Provider

terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.1"
    }
  }
}

# BIG-IP Provider
# Set via GitHub Action Secrets

# provider "bigip" {
#   address  = var.hostname
#   username = var.username
#   password = var.password
# }