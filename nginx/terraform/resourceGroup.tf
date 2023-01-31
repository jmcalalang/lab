resource "azurerm_resource_group" "nginx-terraform-rg" {
  name     = "nginx-terraform-rg"
  location = var.location
}