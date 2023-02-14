# Main Terraform Provider

terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.16.1"
    }
  }
}

provider "bigip" {
  # Configuration options
  # Set as Environment Variables
}