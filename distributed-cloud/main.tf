# Main Terraform Provider

terraform {
  backend "local" {
    path = "distributed-cloud/terraform.tfstate"
  }
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "latest"
    }
    acme = {
      source  = "vancluever/acme"
      version = "latest"
    }
  }
}

# F5XC Provider

provider "volterra" {
  api_p12_file = "../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}

# Acme Challenge Provider

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}