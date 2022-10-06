# Main

# F5XC Provider

terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.14"
    }
  }
}

provider "volterra" {
  api_p12_file = "../certs/f5-sa.console.ves.volterra.io.api-creds.p12"
  url          = "https://f5-sa.console.ves.volterra.io/api"
}