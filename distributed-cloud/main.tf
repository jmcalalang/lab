# Main

# F5XC Provider

terraform {
  backend "local" {
    path = "distributed-cloud/terraform.tfstate"
  }
  required_providers {
    volterra = {
      source  = "volterraedge/terraform-provider-volterra"
      version = "0.11.14"
    }
  }
}

provider "volterra" {
  api_p12_file = "../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}
